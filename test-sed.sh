#!/bin/bash

DIR=/tmp/sed-test
FILE=$DIR/test.dat

# prepare
mkdir /tmp/sed-test
echo "abc" > $FILE
echo "def" >> $FILE
echo "ghi" >> $FILE
cat $FILE

# run
sed -i s/def/123/ $FILE

echo ""
# check
cat $FILE
