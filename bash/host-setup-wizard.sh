#!/bin/bash

set -euo pipefail

source base-utils.sh
source config-utils.sh

readonly CONFIG_FILE=~/slag-configurations/global.properties

PROTOCOL=

function append_to_protocol {
  PROTOCOL="$PROTOCOL$1\n"
}

function ui {
  user_input "$1"
}

function tomcat_application_server_wizard {
  log "set up feature 'tomcat application server'..."
  cd ~/slag-tools/bash

  read_config_value "server.tomcat.installation.dir.parent" $CONFIG_FILE
  local tc_inst_dir_parent=$CONFIG_VALUE

  read_config_value "server.tomcat.name" $CONFIG_FILE
  local tc_name=$CONFIG_VALUE
  local tc_inst_dir=$tc_inst_dir_parent/$tc_name

  read_config_value "server.tomcat.download.url" $CONFIG_FILE
  local tc_dl_url=$CONFIG_VALUE

  log "tc inst dir: '$tc_inst_dir'"
  log "tc dl url: '$tc_dl_url'"

  cd $tc_inst_dir_parent
  local target_file=$tc_name.tar.gz

  log "download tomcat to '$target_file'..."
  curl -o $target_file $tc_dl_url

  log "unzip tomcat from '$target_file'..."
  tar -xf $target_file

  log "set symbolic link..."
  ln -sf $tc_name apache-tomcat-current

  log "start tomcat..."
  cd $tc_inst_dir_parent/apache-tomcat-current/bin
  bash -euo pipefail ./startup.sh

  log "add entry in cron.rebootly..."
  echo "#!/bin/bash" > /etc/cron.rebootly/start_tomcat
  echo "$tc_inst_dir_parent/apache-tomcat-current/bin/startup.sh" >> /etc/cron.rebootly/start_tomcat
  chmod +x /etc/cron.rebootly/start_tomcat

  append_to_protocol "set up 'tomcat application server' feature: OK"
  log "set up feature 'tomcat application server'. done." 
}

function home_host_wizard {
  log_info "set up feature 'home host'..."
  cd ~/slag-tools/bash
  bash -euo pipefail ./host-setup-local.sh
  
  echo "#!/bin/bash" > /etc/cron.minutely/mount_all
  echo "mount -a" >> /etc/cron.minutely/mount_all
  chmod +x /etc/cron.minutely/mount_all

  append_to_protocol "set up 'home host' feature: OK"
  log_info "set up feature 'home host'. done."
}

function install_package {
  local package_name=$1
  ui "install '$package_name'"
  apt-get -y install $package_name
  append_to_protocol "installed: '$package_name'"
}

function extend_crontab {
  log_info "set up feature 'extend crontab'..."
  local ts=$(date '+%Y-%m-%d_%H-%M-%S')
  local crontab_backup_name="/etc/crontab.bak-$ts"
  log_info "backup '/etc/crontab' to '$crontab_backup_name'"

  log_debug "backup '/etc/crontab'..."
  cp /etc/crontab $crontab_backup_name

  log_debug "create dirs for new crontab entries..."
  mkdir /etc/cron.rebootly
  mkdir /etc/cron.minutely

  log_debug "append entries to '/etc/crontab'..."
  echo "@reboot         root    cd / && run-parts --report /etc/cron.rebootly" >> /etc/crontab
  echo "* * * * *       root    cd / && run-parts --report /etc/cron.minutely" >> /etc/crontab

  append_to_protocol "set up 'extend crontab' feature: OK"
  log_info "set up feature 'extend crontab'. done."
}

clear
printf "\n\n # MAIN PROGRAM #\n"

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

echo ""
echo "Protocol:"
printf "$PROTOCOL"
echo ""

log "all done!"

