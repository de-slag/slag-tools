#!/bin/bash

LOG_LEVEL_TRACE=0
LOG_LEVEL_DEBUG=1
LOG_LEVEL_INFO=2
LOG_LEVEL_WARN=3
LOG_LEVEL_ERROR=4

LOG_LEVEL=INFO
LOG_LEVEL_ORDINAL=
LOG_LEVEL_TEXT=

function log {
  log_info "$1"
}

function log_level_ordinal0 {
  if [ "TRACE" == "$LOG_LEVEL" ] ; then LOG_LEVEL_ORDINAL=$LOG_LEVEL_TRACE ; fi
  if [ "DEBUG" == "$LOG_LEVEL" ] ; then LOG_LEVEL_ORDINAL=$LOG_LEVEL_DEBUG ; fi
  if [ "INFO" == "$LOG_LEVEL" ] ; then LOG_LEVEL_ORDINAL=$LOG_LEVEL_INFO ; fi
  if [ "WARN" == "$LOG_LEVEL" ] ; then LOG_LEVEL_ORDINAL=$LOG_LEVEL_WARN ; fi
  if [ "ERROR" == "$LOG_LEVEL" ] ; then LOG_LEVEL_ORDINAL=$LOG_LEVEL_ERROR ; fi
}

function log_level_text0 {
  local severity=$1
  if [ $LOG_LEVEL_TRACE -eq $severity ] ; then LOG_LEVEL_TEXT="TRACE" ; fi
  if [ $LOG_LEVEL_DEBUG -eq $severity ] ; then LOG_LEVEL_TEXT="DEBUG" ; fi
  if [ $LOG_LEVEL_INFO -eq $severity ] ; then LOG_LEVEL_TEXT="INFO" ; fi
  if [ $LOG_LEVEL_WARN -eq $severity ] ; then LOG_LEVEL_TEXT="WARN" ; fi
  if [ $LOG_LEVEL_ERROR -eq $severity ] ; then LOG_LEVEL_TEXT="ERROR" ; fi
}

function log0 {
  local severity=$1
  local message=$2

  log_level_ordinal0

  if [ $severity -lt $LOG_LEVEL_ORDINAL ] ; then
    return
  fi

  log_level_text0 $severity

  local ts=$(date '+%Y-%m-%d %H:%M:%S')
  local log_entry="$ts [$LOG_LEVEL_TEXT] - $message"
  printf "$log_entry\n"
}

function log_info {
  log0 $LOG_LEVEL_INFO "$1"
}

function log_warn {
  log0 $LOG_LEVEL_WARN "$1"
}

function log_error {
  log0 $LOG_LEVEL_ERROR "$1"
}

function log_debug {
  log0 $LOG_LEVEL_DEBUG "$1"
}

function log_trace {
  log0 $LOG_LEVEL_TRACE "$1"
}
