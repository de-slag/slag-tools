#!/bin/bash

TS=$(date +%s)

FILE=/tmp/test-$TS.dat

# prepare
echo "abc" > $FILE
echo "def" >> $FILE
echo "ghi" >> $FILE
cat $FILE

# run
sed -i s/def/123/ $FILE

echo ""
# check
cat $FILE
