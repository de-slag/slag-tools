#!/bin/bash

source logging-utils-1.sh 

function assert_not_null {
  local value_description=$1
  local value=$2

  assert_not_null "value description" $value_description
  if [ -z $2 ] ; then
    log_error "$1 is NULL"
    exit 1
  fi
}
