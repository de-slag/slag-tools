#!/bin/bash
echo "test"

readonly WORKDIR=/media/data/print/kyocera-fs-1030d

TIMESTAMP=$(date +%s)

#cd $WORKDIR
#lp *.pdf 
tar -czvf $TIMESTAMP.tar.gz *.pdf > $TIMESTAMP-tar-gz.log
rm *.pdf

