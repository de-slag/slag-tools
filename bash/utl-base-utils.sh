#!/bin/bash

source ~/slag-tools/bash/utl-logging-utils.sh

## @description: Asserts that the value is not null, gives a readable error log and exit 1 if. Value_description must not be null. Less in relevance when using 'set -u'
## @parameter: value_description, value
## @return: void
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


## @description: Asserts that the user is root. Exit 1, if not.
## @parameter: none
## @return: void
function assert_user_root {
  if [ "$EUID" -ne 0 ] ; then
    log_error "user is not root"
    exit 1
  fi
}

## @description: Prints a text and returns the following user input
## @parameter: text
## @return: USER_INPUT
USER_INPUT=
function user_input {
  local text="$1"
  USER_INPUT=
  printf "$text "
  read USER_INPUT
}

## @description: A short wrapper for 'user_input'
function ui {
  user_input "$1"
}


## @description: Builds a user friendly numbered output using a given list (blank separated) and returns the value of the list, that the user-input number is representing.
## @parameter: select_list
## @return: SELECTED_ITEM
SELECTED_ITEM=
function user_select_item {
  local select_list="$1"
  SELECTED_ITEM=

  idx=0
  for item in $select_list ; do
    echo "$idx - $item"
    idx=$((idx+1))
  done

  ui "select an entry:"
  if [ -z $USER_INPUT ] ; then
    log_debug "noting selected, return"
    return
  fi
  local selected_entry=$USER_INPUT
  log_debug "selected entry: $selected_entry"

  local number_regex='^[0-9]+$'
  if ! [[ $selected_entry =~ $number_regex ]] ; then
     log_warn "selection is not a number: '$selected_entry', return"
     return
  fi

  current_idx=0

  for item in $select_list ; do
    if [ $current_idx -lt $selected_entry ] ; then
      log_trace "current index '$current_idx' is lower than selected entry '$selected_entry', skipping"
      current_idx=$((current_idx+1))
      continue
    fi
    SELECTED_ITEM=$item
    return
  done
  log_warn "invalid selection: '$selected_entry', out ouf '$select_list'"
}

## @parameter: dir_name
## @return: void
function mkdir_if_any {
  local dir_name=$1

  if [ -d $dir_name ] ; then
    log_debug "directory already exists: '$dir_name', return"
    return
  fi

  log_debug "create dir '$dir_name'"
  mkdir -p $dir_name
}


