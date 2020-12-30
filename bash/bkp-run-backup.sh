#!/bin/bash

set -euo pipefail

if [ "--help" == "$1" ] ; then
  echo "usage: bkp-run-backup.sh [--full] SOURCE_PARENT SNAPSHOT_PARENT BACKUP_PARENT SOURCE"
  echo "example: bkp-run-backup.sh /path/to/source-parent /path/to/snapshot-parent /path/to/backup-parent subdir-name-to-backup"
  echo
  echo "options:"
  echo "--full     Runs a full backup. '.no-backup'-files will be ignored. Must be first parameter."
  exit
fi

CLEANUP_MODE=1
if [ "--full" == "$1" ] ; then
  CLEANUP_MODE=0
  shift
fi

SOURCE_PARENT=$1
SNAPSHOT_PARENT=$2
BACKUP_PARENT=$3
SOURCE=$4

./bkp-create-snapshot.sh -p=$SOURCE_PARENT -t=$SNAPSHOT_PARENT -s=$SOURCE
if [ 1 -eq $CLEANUP_MODE ] ; then
  ./bkp-cleanup-traverse-not-to-backup.sh -d=$SNAPSHOT_PARENT/$SOURCE
fi
./bkp-create-backup.sh -p=$SNAPSHOT_PARENT -s=$SOURCE -t=$BACKUP_PARENT
