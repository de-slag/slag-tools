#!/bin/bash

# version 0.1

set -euo pipefail

source base-utils.sh
source config-utils.sh

readonly CONFIG_FILE=~/slag-configurations/global.properties

PROTOCOL=
SCRIPT_OUTPUT=

function append_to_protocol {
  PROTOCOL="$PROTOCOL$1\n"
}


function append_to_output {
  SCRIPT_OUTPUT="$SCRIPT_OUTPUT$1\n"
}

function ui {
  user_input "$1"
}

function tomcat_application_server_wizard {
  log "set up feature 'tomcat application server'..."
  append_to_output "cd ~/slag-tools/bash"

  read_config_value "server.tomcat.installation.dir.parent" $CONFIG_FILE
  local tc_inst_dir_parent=$CONFIG_VALUE

  read_config_value "server.tomcat.name" $CONFIG_FILE
  local tc_name=$CONFIG_VALUE
  local tc_inst_dir=$tc_inst_dir_parent/$tc_name

  read_config_value "server.tomcat.download.url" $CONFIG_FILE
  local tc_dl_url=$CONFIG_VALUE

  log "tc inst dir: '$tc_inst_dir'"
  log "tc dl url: '$tc_dl_url'"

  append_to_output "cd $tc_inst_dir_parent"
  local target_file=$tc_name.tar.gz

  log "download tomcat to '$target_file'..."
  append_to_output "curl -o $target_file $tc_dl_url"

  log "unzip tomcat from '$target_file'..."
  append_to_output "tar -xf $target_file"

  log "set symbolic link..."
  append_to_output "ln -sf $tc_name apache-tomcat-current"

  log "start tomcat..."
  append_to_output "cd $tc_inst_dir_parent/apache-tomcat-current/bin"
  append_to_output "bash -euo pipefail ./startup.sh"

  log "add entry in cron.rebootly..."
  append_to_output "echo '#!/bin/bash' > /etc/cron.rebootly/start_tomcat"
  append_to_output "echo '$tc_inst_dir_parent/apache-tomcat-current/bin/startup.sh' >> /etc/cron.rebootly/start_tomcat"
  append_to_output "chmod +x /etc/cron.rebootly/start_tomcat"

  append_to_protocol "set up 'tomcat application server' feature: OK"
  log "set up feature 'tomcat application server'. done." 
}

function home_host_wizard {
  log_info "set up feature 'home host'..."
  append_to_output "cd ~/slag-tools/bash"
  append_to_output "bash -euo pipefail ./host-setup-local.sh"
  
  append_to_output "echo '#!/bin/bash# > /etc/cron.minutely/mount_all"
  append_to_output "echo 'mount -a' >> /etc/cron.minutely/mount_all"
  append_to_output "chmod +x /etc/cron.minutely/mount_all"

  append_to_protocol "set up 'home host' feature: OK"
  log_info "set up feature 'home host'. done."
}

function install_package {
  local package_name=$1
  ui "install '$package_name'"
  append_to_output "apt-get -y install $package_name"
  append_to_protocol "installed: '$package_name'"
}

function extend_crontab {
  append_to_output "#extend crontab:"
  log_info "set up feature 'extend crontab'..."
  local ts=$(date '+%Y-%m-%d_%H-%M-%S')
  local crontab_backup_name="/etc/crontab.bak-$ts"
  log_info "backup '/etc/crontab' to '$crontab_backup_name'"

  log_debug "backup '/etc/crontab'..."
  append_to_output "cp /etc/crontab $crontab_backup_name"

  log_debug "create dirs for new crontab entries..."
  append_to_output "mkdir /etc/cron.rebootly"
  append_to_output "mkdir /etc/cron.minutely"

  log_debug "append entries to '/etc/crontab'..."
  append_to_output "echo '@reboot         root    cd / && run-parts --report /etc/cron.rebootly' >> /etc/crontab"
  append_to_output "echo '* * * * *       root    cd / && run-parts --report /etc/cron.minutely' >> /etc/crontab"

  append_to_output ""

  append_to_protocol "set up 'extend crontab' feature: OK"
  log_info "set up feature 'extend crontab'. done."
}

clear
printf "\n\n # MAIN PROGRAM #\n"


read_config_value "vrt.base.dir" $CONFIG_FILE
readonly VRT_BASE_DIR=$CONFIG_VALUE


read_config_value "vrt.init.subdir" $CONFIG_FILE
readonly VRT_INIT_SUBDIR=$CONFIG_VALUE

readonly VRT_INIT_DIR=$VRT_BASE_DIR/$VRT_INIT_SUBDIR

ui "(t)omcat application server\n(h)ome host\nenter some host features (blank separated):"
OUTPUT_DIR=$USER_INPUT

ui "(t)omcat application server\n(h)ome host\nenter some host features (blank separated):"
FEATURES=$USER_INPUT
echo "you choosed: '$FEATURES'"

extend_crontab

for feature in $FEATURES
do
   log "you choosed: $feature"
   case "$feature" in
   t)
     install_package curl
     install_package openjdk-11-jdk

     tomcat_application_server_wizard
     continue;;
   h)
     install_package nfs-common

     home_host_wizard
     continue;;
esac
done

read_config_value "vrt" $CONFIG_FILE
local tc_dl_url=$CONFIG_VALUE

echo ""
echo "Protocol:"
printf "$PROTOCOL"
printf "$SCRIPT_OUTPUT" > /tmp/generated.dat
echo ""

log "all done!"

