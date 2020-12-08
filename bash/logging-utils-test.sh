#!/bin/bash

source logging-utils.sh


case "$1" in
  "info")
    log_info "this is an info"
    ;;
  "error")
    log_error "this is an error"
    ;;
  "warn")
    log_warn "this is a warn"
    ;;
  "debug")
    log_debug "log this a debug"
    ;;
  "trace")
    log_trace "log this a trace"
    ;;
  *)
    echo "not valid: $1"
    exit 1
    ;;
esac
