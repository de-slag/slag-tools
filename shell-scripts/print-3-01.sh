#!/bin/bash

source utils-base-1-01.sh

function setup {
  log_always "setup" main
  read_default_cli_params "$@"
  setup_base_utils
  log_always "setup done\n" main
}

setup "$@"


readonly WORKDIR=/media/data/print/kyocera-fs-1030d
readonly TRIGGER=print.trigger
readonly VERSION=3.1

TIMESTAMP=$(date +%s)



dev=true
if [ true == $dev ] ; then
  log_always dev2 main
  exit 0
fi

exit 1



cd $WORKDIR

ls

if [ ! -e $TRIGGER ] ; then
  echo 'do nothing'
  exit 0
fi

LOGFILE=$TIMESTAMP-tar-gz.log

lp *.pdf 
echo "$VERSION" > $LOGFILE
tar -czvf $TIMESTAMP.tar.gz *.pdf >> $LOGFILE

rm *.pdf

rm $TRIGGER

