#!/bin/bash

source ~/slag-tools/bash/core-script.sh

TS=$(date $TIMESTAMP_PATTERN)

UI_FROM=
UI_TO=

function print_help {
  echo "synthax: move-jpgs.sh [options]"
  echo ""
  echo "options:"
  echo "-h  --help                print this help"
  echo "-s  --source-dir          directory where jpgs are resided, mandatory"
  echo "-t  --target-dir-parent   parent dir where jpgs should be moved to, mandatory"
  echo ""
  echo "example: move-jpgs.sh -s=/path/to/jpgs -t=/path/moved/to"
}

for i in "$@" ; do
  case $i in
    -s=*|--source-dir=*)
      UI_FROM="${i#*=}"
      shift
      ;;
    -t=*|--target-dir-parent=*)
      UI_TO="${i#*=}"
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

if [ -z $UI_FROM ] ; then
  log_error "'source-dir' not setted. Start with '-h' for help. Exit'"
  exit 1
fi

if [ -z $UI_TO ] ; then
  log_error "'target-dir-parent' not setted. Start with '-h for help. 'Exit'"
  exit 1
fi

if [ ! -d $UI_FROM ] ; then
  log_error "'source-dir' not found: '$UI_FROM'"
  exit 1
fi

if [ ! -d $UI_TO ] ; then
  log_error "'target-dir-parent' not found: '$UI_TO'"
  exit 1
fi

FROM=$UI_FROM
TO=$UI_TO/$TS

log_debug "check if something to do..."
contains_files_with_extension $FROM jpg
if [ $CONTAINS_FILES_WITH_EXTENSION != true ] ; then
  log_info "nothing to do"
  exit 0
fi

log_debug "ok, there IS something to do"

mkdir $TO

cp -v $FROM/*.jpg $TO
rm -v $FROM/*.jpg

chmod -R +x $TO

log_info "all done"
