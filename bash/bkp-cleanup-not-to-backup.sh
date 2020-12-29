#!/bin/bash
set -euo pipefail

for i in "$@"
do
case $i in
    -d=*|--dir-to-cleanup=*)
      DIR="${i#*=}"
      shift # past argument=value
      ;;
    -h|--help)
      echo "usage bkp-cleanup-not-to-backup.sh -d=/dir/to/cleanup"
      ;;
    *)
      # unknown option
      ;;
esac
done

ALL_ENTRIES=$(ls -a $DIR)
echo "$ALL_ENTRIES"

for entry in $ALL_ENTRIES
do
  if [ "." == "$entry" ] || [ ".." == "$entry" ] ; then
    echo "it is this/parent dir: '$entry', skipping"
    continue
  fi

  dir_entry=$DIR/$entry
  if [ -f $dir_entry ] ; then
    echo "it is a regular file: '$entry', skipping"
    continue
  fi
  no_backup_file=$DIR/$entry/.no-backup
  if [ ! -e $no_backup_file ] ; then
    echo "no-backup-file '$no_backup_file' not found in '$dir_entry', skipping"
    continue
  fi
  echo "no-backup-file found in: '$dir_entry', remove this dir"
  rm -R $dir_entry
done

