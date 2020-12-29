#!/bin/bash
readonly TMP_FILE_NAME=demo-ls-to-list.dat

LIST=$(ls *.sh)
echo $LIST

ls *.sh > $TMP_FILE_NAME

cat $TMP_FILE_NAME
rm $TMP_FILE_NAME
