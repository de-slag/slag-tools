#!/bin/bash

readonly UTILS_DIR=~/slag-tools/utils
readonly CONFIG_DIR=~/slag-configurations

source $UTILS_DIR/base-utils-stable.sh
source $UTILS_DIR/logging-utils-stable.sh

PROPERTIES_FILE=$CONFIG_DIR/global.properties

CONFIG_VALUE=

KEY=
VALUE=
function split_key_value0 {
  local string=$1
  local splitterator=$2

  KEY=""
  VALUE=""

  OIFS=$IFS
  IFS='='

  for token in $line
  do
    if [ -z $KEY ] ; then
      KEY=$token
      continue
    fi
    VALUE=$token
  done
  IFS=$OIFS
}


function read_config_value_from_line0 {
  local line="$1"
  log_debug "processing line '$line'..."

  if [[ "$line" = \#* ]] ; then
    log_debug "$line starts with #, skipping"
    return
  fi

  if [ -z $line ] ; then
    log_debug "line is empty, skipping"
    return
  fi

  log_debug "separate key value pair..."

  split_key_value0 $line

  log_debug "separate key value pair...done"
  log_debug "key: '$KEY', value: '$VALUE'"
}

function read_config_value {
  local config_key=$1
  CONFIG_VALUE=
  
  if [ -z $config_key ] ; then
    log_debug "no config key setted, return"
    return
  fi
  
  log_debug "read properties file..."
  while read line; do
    read_config_value_from_line0 $line
    if [ "$KEY" != "$config_key" ] ; then
      continue
    fi
    CONFIG_VALUE=$VALUE
    log_debug "config value found: $CONFIG_VALUE"
    break
  done < $PROPERTIES_FILE 
}

if [ ! -f $PROPERTIES_FILE ] ; then
  log_error "global configuration not found: $PROPERTIES_FILE"
  exit 1
fi
log_debug "config file found: $PROPERTIES_FILE"
