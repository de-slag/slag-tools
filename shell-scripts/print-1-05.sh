#!/bin/bash

readonly WORKDIR=/media/data/print/kyocera-fs-1030d
readonly TRIGGER=print.trigger
readonly VERSION=1.05

TIMESTAMP=$(date +%s)



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

