#!/bin/bash

# not tested
exit 1

function log {
  printf "$1\n"
}

function log_error {
  log "ERROR: $1"
}

function install_git {
  sudo apt-get install git
}

if [ -z $1 ] ; then
  log_error "no argument"
  exit 1
fi

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

