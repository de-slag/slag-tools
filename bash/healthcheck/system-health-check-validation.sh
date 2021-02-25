#!/bin/bash

source ~/slag-tools/bash/core-script.sh

read_config_value lhc.logcache.maxage.days
LOGCACHE_MAX_AGE_DAYS=$CONFIG_VALUE

read_config_value lhc.logcache
LOGCACHE=$CONFIG_VALUE

function assert_log_cache_dir {
  if [ ! -d $LOGCACHE ] ; then
    log_warn "logcache not found. exit"
    exit 0
  fi
}

CURRENT_MIN_VALID_TIMESTAMP=
function calculate_parameters {
  local current_ts=$(date +%s)
  local max_days_in_seconds=$(($LOGCACHE_MAX_AGE_DAYS*24*3600))
  CURRENT_MIN_VALID_TIMESTAMP=$(($current_ts-$max_days_in_seconds))
  log_debug "CURRENT_MIN_VALID_TIMESTAMP: $CURRENT_MIN_VALID_TIMESTAMP"
}

LOG_CACHE_AGE_VALID=
function analyze_log_cache_dir {
  cd $LOGCACHE
  local files_list=$(ls)
  
  for file in $files_list ; do
    file_ts=$(stat -c %Y "$file")
    log_debug "file last modified: $file_ts"
    if [ $CURRENT_MIN_VALID_TIMESTAMP -gt $file_ts ] ; then
      LOG_CACHE_AGE_VALID=false
      return
    fi
  done
  LOG_CACHE_AGE_VALID=true
}

function create_report {

  local ts=$(date "+%Y-%m-%d %H:%M:%S")
  local test_name="system health check validation"
  local report_file=$LOGCACHE/system-health-check-validation.log
 
  if [ "true" == "$LOG_CACHE_AGE_VALID" ] ; then
    echo "[ OK ] $test_name, $ts" > $report_file
    return
  fi
  echo "[ FAILED ] $test_name, $ts, one or more tests are overaged!" > $report_file
  
}



assert_log_cache_dir
calculate_parameters
analyze_log_cache_dir
create_report


log_info "all done"
