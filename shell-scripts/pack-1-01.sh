#!/bin/bash

readonly EXTENSION=properties

PACK_FILE=$1.$EXTENSION

function log {
  local TS=$(date '+%Y-%m-%d %H:%M:%S.%6N')
  printf "$TS : $1\n"
}

function log_info {
  log "[INFO] $1"
}

function validate_arg {

  log_info "argument validation..."

  if [ -z $1 ] ; then
    log "ERROR: no argument setted"
    exit 1
  fi

  if [ ! -f $PACK_FILE ] ; then
    log "ERROR: '$PACK_FILE' is not a file"
    exit 1
  fi
  
  log_info "INFO: argument validation done."
}


validate_arg $1

version=
includes=
script=

function assert_not_null {
  local NAME=$1
  local VALUE=$2
  
  echo $1

  if [ -z $1 ] ; then
    log "ERROR: semantic failure: 'NAME' is not setted"
	exit 1
  fi  
  
  if [ -z $2 ] ; then
    log "ERROR: '$NAME' is null"
	exit 1
  fi
}


KEY=
VALUE=
function split_at {
  local separator=$1
  local string_to_split=$2
  
  echo $separator
  echo $string_to_split

  assert_not_null "separator" $separator
  assert_not_null "string to split" $string_to_split
  
  ARRAY=(${string_to_split//;/ })
  
  KEY=$ARRAY[0]
  VALUE=$ARRAY[1]
  
}


function read_pack_file {
  log_info "read pack file..."

  input=$PACK_FILE
  while IFS= read -r line
  do
    if
    echo "$line"
	split_at "=" "$line"
	echo "$KEY: $VALUE"
  done < "$input"
  
  log_info "read pack file done"
}

function validate_packing_properties {
    log_info "validate packing properties..."
    assert_not_null "VERSION" $VERSION
	assert_not_null "SCRIPT" $SCRIPT
    
	log_info "validate packing properties done"
}

read_pack_file
exit 0
validate_packing_properties

FINAL_FILENAME=

function derive_values {
  FINAL_FILENAME=$SCRIPT-$VERSION
}

log_info "all done"
