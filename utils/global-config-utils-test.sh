#!/bin/bash

source logging-utils-stable.sh

if [ "$1" = "LATEST" ] ; then
  source global-config-utils-latest.sh
else
  source global-config-utils-stable.sh
fi

function assert_equals {
  local message=$1
  local expected=$2
  local current=$3
  log_debug "compare '$expected' with '$current'"
  if [ "$expected" != "$current" ] ; then
    echo "not equal. expected '$expected', current '$current'"  
    return
  fi
  echo "ok: $message"
}

read_config_value
assert_equals "no key" "" $CONFIG_VALUE

read_config_value test.lorem.ipsum
assert_equals "lorem ipsum" "Lorem ipsum dolor sit amet." $CONFIG_VALUE

