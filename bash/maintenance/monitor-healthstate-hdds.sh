#!/bin/bash

source ~/slag-tools/bash/core-script.sh

readonly TS=$(date $TIMESTAMP_PATTERN)

log_debug "timestamp for current run is '$TS'"

#function collect_data {

#}

#function generate_report {

#}

function assert_log_dir {
  read_config_value healthstate.log.dir
  local healthstate_log_dir=$CONFIG_VALUE

  if [ ! -e $healthstate_log_dir ] ; then
    log_info "log dir not found. create '$healthstate_log_dir'"
    mkdir -p $healthstate_log_dir
  else
    log_debug "log dir found: '$healthstate_log_dir', ok"
  fi
}

assert_log_dir

log_info "all done!"
