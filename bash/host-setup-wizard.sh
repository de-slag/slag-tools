#!/bin/bash

set -euo pipefail

source base-utils.sh
source config-utils.sh
readonly CONFIG_FILE=~/slag-configurations/global.properties

function ui {
  user_input "$1"
}

function tomcat_application_server_wizard {
  log "tomcat application server"

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
  ln -sf $tc_name apache-tomcat-current
  
}

function home_host_wizard {
  log_info "start: host setup local..."
  bash -euo pipefail ./host-setup-local.sh
  log_info "start: host setup local. done."
}

clear
printf "\n\n # MAIN PROGRAM #\n"

ui "(t)omcat application server\n(h)ome host\nenter some host features (blank separated):"
FEATURES=$USER_INPUT
echo "you choosed: '$FEATURES'"

for feature in $FEATURES
do
   log "you choosed: $feature"
   case "$feature" in
   t)
     tomcat_application_server_wizard
     continue;;
   h)
     home_host_wizard
     continue;;
esac
done

log "all done!"

