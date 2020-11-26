#!/bin/bash

KEY=""
VALUE=""
function split_into_key_value {
  local key_value=$1
  if [ -z $key_value ] ; then
    echo "key-value-string is empty"
    exit 1
  fi

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

