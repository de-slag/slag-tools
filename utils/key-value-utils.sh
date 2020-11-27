#!/bin/bash

KEY=""
VALUE=""

function split_into_key_value {
  local key_value=$1
  assert_not_null "key_value" $key_value
  KEY=""
  VALUE=""

  OIFS=$IFS
  IFS='='

  for token in $key_value
  do
    if [ -z $KEY ] ; then
      KEY=$token
      continue
    fi
    VALUE=$token
  done
  IFS=$OIFS
}

split_into_key_value $1
