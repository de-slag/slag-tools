#!/bin/bash

source utils-log-1-01.sh

LOG_LEVEL=INFO
setup_log_utils

log_info "DEMO find files older than..." main


OLDER_THAN=
function is_older_than_days {
  OLDER_THAN=
  if [ ! -f $1 ] ; then
    OLDER_THAN=0
    return 0
  fi
  OLDER_THAN=1
}



array=$("ls")

## echo $array

for i in $array
do
  if [ "$OLDER_THAN" == "1" ] ; then
    log_debug "file is not older than: $i"
  fi
  echo "older than: $i"
done