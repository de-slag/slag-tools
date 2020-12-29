#!/bin/bash

readonly TIMESTAMP=$(date +%s)
readonly TMP_FILE=$TIMESTAMP-demo-all.dat
echo $TMP_FILE

ls demo*.sh > $TMP_FILE

while IFS= read -r line
do
  if [ "$0" == "./$line" ] ; then
    echo "skip: $line"
    continue
  fi
  echo
  echo
  echo \## $line \##
  echo
  (bash $line)
  echo
  echo \## /$line \##
done < "$TMP_FILE"

rm $TMP_FILE
