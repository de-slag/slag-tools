#!/bin/bash

source ~/slag-tools/bash/core-script.sh

log_debug "start: '$0 $@'"

WORKDIR=

function print_help {
  echo "synthax: convert-jpgs-to-gifs.sh [options]"
  echo ""
  echo "options:"
  echo "-h  --help              print this help"
  echo "-w  --work-dir          directory with subdirectories containing jpgs"
  echo ""
  echo "example: convert-jpgs-to-gifs.sh -w=/path/with/jpg/containing/subdirs"
}

for i in "$@" ; do
  case $i in
    -w=*|--work-dir=*)
      WORKDIR="${i#*=}"
      shift
      ;;
    -h|--help)
      print_help
      exit 0
      ;;
    *)
      log_warn "unknown option: $i"
    ;;
  esac
done

if [ -z $WORKDIR ] ; then log_error "'work-dir' not setted. Start with '-h' for help. Exit." ; exit 1 ; fi

function convert_jpgs_from_directory_to_gif {
  local directory=$1
  log_debug "convert_jpgs_from_directory_to_gif: '$directory'"

  #untested, check parameters 'delay' and 'loop'
  local cmd="convert -delay 20 -loop 0 $directory/*.jpg $directory.gif"
  log_error "not implemented yet: '$cmd'"
}

function process_entry {
  local entry=$1
  log_debug "process entry: '$entry'"
  if [ ! -d $entry ] ; then
    log_debug "entry is not a dir: '$entry'. return."
    return
  fi
  if [ -f $entry.gif ] ; then
    log_info "directory seems to be already processed: '$entry'. return."
    return
  fi

  contains_files_with_extension $WORKDIR/$entry jpg
  if [ $CONTAINS_FILES_WITH_EXTENSION == false ] ; then
    log_info "directory contains no jpgs: '$entry'. return."
    return
  fi
  convert_jpgs_from_directory_to_gif $entry
}



cd $WORKDIR
DIR_ENTRIES=$(ls)
log_debug "entries: '$DIR_ENTRIES'"
for entry in $DIR_ENTRIES
do
  process_entry $entry
done

log_info "all done"
