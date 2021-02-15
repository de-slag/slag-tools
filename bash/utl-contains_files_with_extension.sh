#!/bin/bash

source ~/slag-tools/bash/utl-logging-utils.sh

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

CONTAINS_FILES_WITH_EXTENSION=
function contains_files_with_extension {
  dir_to_check=$1
  file_extension=$2
  CONTAINS_FILES_WITH_EXTENSION=

  if [ ! -d $dir_to_check ] ; then log_error "not a valid directory: '$dir_to_check'" ; exit 1 ; fi
  if [ -z $file_extension ] ; then log_error "file extension not setted" ; exit 1 ; fi

  # deactivate pipefail because a fail is part of this statement
  set +o pipefail

  count=`ls -1 $dir_to_check/*.$file_extension 2>/dev/null | wc -l`
  set -o pipefail

  if [ $count != 0 ] ; then
    CONTAINS_FILES_WITH_EXTENSION=true
  else
    CONTAINS_FILES_WITH_EXTENSION=false
  fi
}
