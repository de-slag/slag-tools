#!/bin/bash

source logging-utils-stable.sh
source cli-args-utils.sh

if [ -z "$1" ] ; then
   log_info "args are empty, start with defaults"
   $0 "-a=abc -c=this-is-a-config-file --test"
   exit 0
fi

read_cli_argument "-c" "$@"
if [ ! -z $CLI_ARGUMENT ] ; then
  log_info "cli argument found: $CLI_ARGUMENT"
else
  log_error "cli argument NOT found!"
fi

log_info "all done"
