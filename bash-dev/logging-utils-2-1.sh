#!/bin/bash

function log {
  log_info "$1"
}

function log0 {
  local severity=$1
  local message=$2

  local ts=$(date '+%Y-%m-%d %H:%M:%S')
  local log_entry="$ts [$severity] - $message"
  printf "$log_entry\n"
}

function log_info {
  log0 "INFO" "$1"
}

function log_warn {
  log0 "WARN" "$1"
}

function log_error {
  log0 "ERROR" "$1"
}

function log_debug {
  log0 "DEBUG" "$1"
}

function log_trace {
  log0 "TRACE" "$1"
}

echo "logging-utils, methods:"
echo "  log (text)"
echo "  log_error (text)"
echo "  log_warn (text)"
echo "  log_info (text)"
echo "  log_debug (text)"
