#!/bin/bash

source ~/slag-tools/bash/core-script.sh

TS=$(date +%s)

UI_FROM=
UI_TO=

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
    *)
      echo "unknown option: $i"
    ;;
  esac
done

if [ -z $UI_FROM ] ; then
  log_error "'from' not setted. exit'"
  exit 1
fi

if [ -z $UI_TO ] ; then
  log_error "'to' not setted. exit'"
  exit 1
fi

if [ ! -d $UI_FROM ] ; then
  echo "from-dir not found: '$UI_FROM'"
  exit 1
fi

if [ ! -d $UI_TO ] ; then
  echo "to-dir not found: '$UI_TO'"
  exit 1
fi

FROM=$UI_FROM
TO=$UI_TO/$TS

echo "check if something to do..."
contains_files_with_extension $FROM jpg
if [ $CONTAINS_FILES_WITH_EXTENSION != true ] ; then
  echo "nothing to do"
  exit 0
fi

echo "ok, there IS something to do"

mkdir $TO

cp -v $FROM/*.jpg $TO
rm -v $FROM/*.jpg

echo "all done"
