#!/bin/bash
version=1.01

LOG_TRACE=0
LOG_DEBUG=0
LOG_INFO=0
LOG_WARN=0
LOG_LEVEL=WARN


function log {
  local severity=$1
  local message=$2
  local method_info=$3
  
  if [ -z $method_info ] ; then
    log0 "$severity" "$message" "(unknown)"
  else
    log0 "$severity" "$message" "$method_info"
  fi
}

function log0 {
  local severity=$1
  local message=$2
  local method_info=$3

  local ts=$(date '+%Y-%m-%d %H:%M:%S')
  local log_entry="$ts [$severity] $method_info - $message"
  printf "$log_entry\n"
}

function log_always {
  log "ALWAYS" "$1" "$2"
}

function log_info {
  if [ 0 -eq $LOG_INFO ] ; then
    return 0
  fi 
  log "INFO" "$1" "$2"
}

function log_warn {
  if [ 0 -eq $LOG_WARN ] ; then
    return 0
  fi 
  log "WARN" "$1" "$2"
}

function log_error {
  log "ERROR" "$1" "$2"
}

function log_fatal {
  log "FATAL" "$1" "$2"
}

function log_debug {
  if [ 0 -eq $LOG_DEBUG ] ; then
    return 0
  fi  
  log "DEBUG" "$1" "$2"
}

function log_trace {
  if [ 0 -eq $LOG_TRACE ] ; then
    return 0
  fi  
  log "TRACE" "$1" "$2"
}

function set_up_logging {
  if [ "TRACE" == "$LOG_LEVEL" ] ; then
    LOG_TRACE=1
    LOG_DEBUG=1
	LOG_INFO=1
	LOG_WARN=1
	log0 SETUP "set log level: TRACE" LOGUTILS.set_up_logging
    return 0
  fi

  if [ "DEBUG" == "$LOG_LEVEL" ] ; then
    LOG_DEBUG=1
	LOG_INFO=1
	LOG_WARN=1
	log0 SETUP "set log level: DEBUG" LOGUTILS.set_up_logging
    return 0
  fi
  
  if [ "INFO" == "$LOG_LEVEL" ] ; then
    LOG_INFO=1
	LOG_WARN=1
	log0 SETUP "set log level: INFO" LOGUTILS.set_up_logging
    return 0
  fi
  
    if [ "WARN" == "$LOG_LEVEL" ] ; then
	LOG_WARN=1
	log0 SETUP "set log level WARN" LOGUTILS.set_up_logging
    return 0
  fi
  log0 SETUP "ERROR: log level unknown '$LOG_LEVEL'" LOGUTILS.set_up_logging
  exit 1
}

function set_log_level {
  LOG_LEVEL=$1
  set_up_logging
}

function validate_log_level {
  log0 SETUP "..." LOGUTILS.validate_log_level
  set_log_level $LOG_LEVEL
  log0 SETUP "done" LOGUTILS.validate_log_level
}

function setup_log_utils {
  log0 SETUP "..." LOGUTILS.setup_log_utils
  validate_log_level
  log0 SETUP "done" LOGUTILS.setup_log_utils
}

echo "Log Utils $version"
echo "for setup call 'setup_log_utils'"


