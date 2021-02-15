#!/bin/bash

source ../bash/utl-logging-utils.sh

function ok_log_error_test {
  log_error "$1"
}

function ok_log_info_test {
  log_info "$1"
}

function ok_log_debug_test {
  LOG_LEVEL=$LOG_LEVEL_DEBUG
  log_debug "$1"
}

function ok_log_debug_silence_test {
  log_debug "$1"
}

function ok_log_trace_test {
  LOG_LEVEL=$LOG_LEVEL_TRACE
  log_trace "$1"
}

function ok_log_trace_silence_test {
  log_trace "$1"
}


