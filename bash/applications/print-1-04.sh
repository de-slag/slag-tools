#!/bin/bash

readonly WORKDIR=/media/data/print/kyocera-fs-1030d
readonly TRIGGER=print.trigger

TIMESTAMP=$(date +%s)



cd $WORKDIR

ls

if [ ! -e $TRIGGER ] ; then
  echo 'do nothing'
  exit 0
fi

lp *.pdf 
tar -czvf $TIMESTAMP.tar.gz *.pdf > $TIMESTAMP-tar-gz.log
rm *.pdf

rm $TRIGGER

