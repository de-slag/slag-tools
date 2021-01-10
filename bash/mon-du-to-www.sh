#!/bin/bash
TARGET_DIR=/var/www/html
TARGET_DIR=/tmp
TARGET_FILE=$TARGET_DIR/disk-usage.txt

if [ ! -e $TARGET_DIR ] ; then
  echo "target dir not found. exit"
  exit 1
fi
echo "target dir found, OK"

date  >  $TARGET_FILE
df -h >> $TARGET_FILE

echo "all done"
