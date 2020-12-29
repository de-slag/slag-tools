#!/bin/bash

source base-utils-1.sh

KEY=
VALUE=
function split_key_value {
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
