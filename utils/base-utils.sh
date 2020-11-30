#!/bin/bash

source ~/slag-tools/utils/logging-utils-stable.sh

function assert_not_null {
  if [ -z $1 ] ; then
    echo 
    exit 2
  fi

  if [ -z $2 ] ; then
    echo "$1 is not setted"
    exit 1
  fi
}


