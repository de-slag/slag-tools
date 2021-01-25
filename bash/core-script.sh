#!/bin/bash

source ~/slag-tools/bash/utl-core-utils.sh
source ~/slag-tools/bash/utl-contains_files_with_extension.sh
source ~/slag-tools/bash/utl-constants.sh

set -eo pipefail

if [ "$1" == "DEBUG" ] ; then
  LOG_LEVEL=DEBUG
  log_debug "DEBUG MODE"
  shift
fi

if [ "$1" == "TRACE" ] ; then
  LOG_LEVEL=TRACE
  log_trace "TRACE MODE"
  set -x
  shift
fi

set -u

CONFIG_FILE=~/slag-configurations/global.properties
