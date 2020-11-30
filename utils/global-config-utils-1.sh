#!/bin/bash

readonly UTILS_DIR=~/slag-tools/utils
readonly CONFIG_DIR=~/slag-configurations

source $UTILS_DIR/base-utils-stable.sh
source $UTILS_DIR/logging-utils-stable.sh

if [ -f $CONFIG_DIR/global.properties ] ; then
  log_error "global configuration not found: $CONFIG_DIR/global.properties"
  exit 1
fi
