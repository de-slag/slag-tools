#!/bin/bash

source ~/slag-tools/bash/core-script.sh

#1 execute
#2 write
#4 read

readonly DEFAULT_FILE_RIGHT=666
readonly DEFAULT_FOLDER_RIGHT=777


element_count=0

function set_file_rights_to_element {
  local element=$1
  local user=$2
  local parent=$3

  local element_path="$parent/$element"

  element_count=$((element_count+1))

  chown $user:$user "$element_path"

  if [ -d "$element_path" ] ; then
    log_debug "set rights '$DEFAULT_FOLDER_RIGHT' to '$element_path'"
    chmod $DEFAULT_FOLDER_RIGHT $element_path
    log_debug "going down to: $element_path"
    set_file_rights_to_folder "$element_path" $user
    return
  fi

  if [ -f $element_path ] ; then
    log_debug "set rights '$DEFAULT_FILE_RIGHT' to '$element_path'"
    chmod $DEFAULT_FILE_RIGHT $element_path
    return
  fi

  log_warn "no file or folder: '$element_path', ignored."
}

function set_file_rights_to_folder {
  local folder=$1
  local user=$2

  cd $folder
  folder_entrys=$(ls)

  log_debug "found entries: $folder_entrys"

  for entry in $folder_entrys ; do
    set_file_rights_to_element $entry $user $folder 
  done
}

set_file_rights_to_folder /tmp/own-test sebastian 

log_info "procecced elements: $element_count"



