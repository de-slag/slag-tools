#!/bin/bash

source base-utils-stable.sh
source logging-utils-stable.sh

DEFAULT_PROPERTIES_FILE=~/slag-configurations/global.properties
#PROPERTIES_FILE=~/slag-configurations/global.properties

CONFIG_VALUE=

GLOBAL_CONFIG_UTILS_KEY=
GLOBAL_CONFIG_UTILS_VALUE=
function split_key_value0 {
  local string=$1
  local splitterator=$2

  GLOBAL_CONFIG_UTILS_KEY=""
  GLOBAL_CONFIG_UTILS_VALUE=""

  OIFS=$IFS
  IFS='='

  for token in $line
  do
    if [ -z $GLOBAL_CONFIG_UTILS_KEY ] ; then
      GLOBAL_CONFIG_UTILS_KEY=$token
      continue
    fi
    GLOBAL_CONFIG_UTILS_VALUE="$token"
  done
  IFS=$OIFS
}


function read_config_value_from_line0 {
  local line="$1"
  log_debug "processing line '$line'..."

  if [[ "$line" = \#* ]] ; then
    log_debug "the string '$line' starts with #, skipping"
    return
  fi

  if [ -z "$line" ] ; then
    log_debug "line is empty, skipping"
    return
  fi

  log_debug "separate key value pair..."

  split_key_value0 $line

  log_debug "separate key value pair...done"
  log_debug "key: '$GLOBAL_CONFIG_UTILS_KEY', value: '$GLOBAL_CONFIG_UTILS_VALUE'"
}

function Xassert_properties_file_0 {
  if [ ! -f $PROPERTIES_FILE ] ; then
    log_error "global configuration not found: $PROPERTIES_FILE"
    exit 1
  fi
  log_debug "config file found: $PROPERTIES_FILE"
}


function read_config_value {
  local config_key=$1
  local properties_file=$2
  if [ -z $config_key ] ; then
    log_debug "no config key setted, return"
    return
  fi

  if [ -z $properties_file ] ; then
    log_info "no properties file setted. call functio with default value"
    read_config_value $config_key $DEFAULT_PROPERTIES_FILE
    return
  fi

  if [ ! -f $properties_file ] ; then
    log_error "property file not found: '$properties_file'. exit"
    exit 1
  fi


 # assert_properties_file_0
  CONFIG_VALUE=
  if [ -z $config_key ] ; then
    log_debug "no config key setted, return"
    return
  fi
  
  log_debug "read properties file..."
  while read line; do
    read_config_value_from_line0 "$line"
    if [ "$GLOBAL_CONFIG_UTILS_KEY" != "$config_key" ] ; then
      continue
    fi
    CONFIG_VALUE=$GLOBAL_CONFIG_UTILS_VALUE
    log_debug "config value found: '$CONFIG_VALUE'"
    break
  done < $properties_file
  if [ -z $CONFIG_VALUE ] ; then
    log_debug "config key '$config_key' not found in file '$properties_file'"
  fi
}

echo "global-config-utils, methods:"
echo "  CONFIG_VALUE read_config_value (config_key)"

