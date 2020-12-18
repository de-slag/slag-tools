#!/bin/bash

source logging-utils-1.sh 

function assert_not_null {
  local value_description=$1
  local value=$2

  if [ -z $1 ] ; then
    log_error "value description is NULL"
    exit 1
  fi

  if [ -z $2 ] ; then
    log_error "$1 is NULL"
    exit 1
  fi
}

function assert_user_root {
  if [ "$EUID" -ne 0 ] ; then
    log_error "user is not root"
    exit 1
  fi
}

USER_INPUT=
function user_input {
  local text="$1"
  USER_INPUT=
  printf "$text "
  read USER_INPUT
}

echo "base-utils, methods:"
echo "  assert_not_null (value)"
echo "  assert_user_root ()"
