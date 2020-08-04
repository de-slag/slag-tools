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

function log_debug {
  if [ 0 -eq $LOG_DEBUG ] ; then
    return 0
  fi
  log "DEBUG" "$1" "$2"
}

log_info "logging enabled"


