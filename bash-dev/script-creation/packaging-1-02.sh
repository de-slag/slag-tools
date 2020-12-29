#!/bin/bash
echo
echo "###"

TARGET_FILE_UNVALIDATED=
FILES_TO_PACK_UNVALIDATED=
TARGET_FILE=
FILES_TO_PACK=

function log0 {
  local timestamp=$(date +"%Y-%m-%dT%T.%3N")
  printf "$timestamp [$1] - $2\n"
}

function log_info {
  log0 "INFO" "$1"
}

function log_debug {
  log0 "DEBUG" "$1"
}

function log_warn {
  log0 "WARN" "$1"
}

function log_error {
  log0 "ERROR" "$1"
}

function set_config {
  local key=$1
  local value=$2

  case $key in
    target.filename)
      TARGET_FILE_UNVALIDATED=$value
      ;;

    pack.files)
      FILES_TO_PACK_UNVALIDATED=$value
       ;;

    *)
      log_warn "unknown key: '$key', ignored"
      ;;
  esac
}

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

function read_config_file_line {
  local line=$1
  log_debug "processing line '$line'..."

  if [ -z $line ] ; then
    log_debug "line is empty, skipping"
    continue
  fi

  log_debug "separate key value pair..."

  split_key_value $line

  log_debug "separate key value pair...done"
  log_debug "key: '$KEY', value: '$VALUE'"

  set_config $KEY $VALUE
  KEY=
  VALUE=
}

function read_config_file {
  if [ -z $1 ] ; then
    log_error "no properties file setted"
    exit 1
  fi

  if [ ! -f $1 ] ; then
    log_error "properties file does not exists: '$1'"
    exit 1
  fi

  local properties_file=$1
  log_info "properties file found: '$properties_file'"

  log_debug "read properties file..."
  while read line; do
    read_config_file_line $line
  done < $properties_file
  log_debug "read properties file...done."
}

function validate_config {
  log_info "validate target file: '$TARGET_FILE_UNVALIDATED'"
  if [ -e $TARGET_FILE_UNVALIDATED ] ; then
    echo "[ERROR] - target file already exists: '$TARGET_FILE_UNVALIDATED'"
    exit 1
  fi
  TARGET_FILE=$TARGET_FILE_UNVALIDATED

  OIFS=$IFS
  IFS=';'

  for token in $FILES_TO_PACK_UNVALIDATED
  do
    if [ ! -f $token ] ; then
      echo "[ERROR] - file not exits: $token"
      exit 1
    fi
    if [ ! -z $FILES_TO_PACK ] ; then
      FILES_TO_PACK="$FILES_TO_PACK "
    fi
    FILES_TO_PACK="$FILES_TO_PACK$token"
  done
  IFS=$OIFS

  log_info "target file validated: '$TARGET_FILE'"
  log_info "files to pack: '$FILES_TO_PACK'"

}

function pack_files {
  log_debug "pack files..."

  echo "#/bin/bash" > $TARGET_FILE

  for file in $FILES_TO_PACK
  do
    echo "" >> $TARGET_FILE
    echo "# $file" >> $TARGET_FILE
    cat $file >> $TARGET_FILE
    echo "# end $file" >> $TARGET_FILE
  done

  echo "# end of generated section" >> $TARGET_FILE
  echo "" >> $TARGET_FILE

  log_debug "pack files...done"
}

read_config_file $1
validate_config
pack_files
