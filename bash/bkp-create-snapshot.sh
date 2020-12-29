#!/bin/bash
set -euo pipefail

for i in "$@"
do
case $i in
    -p=*|--source-dir-parent=*)
      SNAPSHOT_PARENT_DIR="${i#*=}"
      shift # past argument=value
      ;;
    -t=*|--target-dir=*)
      TARGET_DIR="${i#*=}"
      shift # past argument=value
      ;;
    -s=*|--source-dir=*)
      SNAPSHOT_DIR="${i#*=}"
      shift # past argument=value
      ;;
    -h|--help)
      echo "usage bkp-create-snapshot.sh -p=/sourcedir/parent -s=source_dir -t=/target/dir"
      ;;
    *)
      # unknown option
      ;;
esac
done

if [ -z $SNAPSHOT_PARENT_DIR ] ; then
  echo "parent-dir-to-snapshot not setted. exit"
  exit 1
fi

if [ -z $TARGET_DIR ] ; then
  echo "TARGET_DIR not setted. exit"
  exit 1
fi

if [ -z $SNAPSHOT_DIR ] ; then
  echo "dir-to-snapshot not setted. exit"
  exit 1
fi

SOURCE_DIR=$SNAPSHOT_PARENT_DIR/$SNAPSHOT_DIR

if [ ! -e $SOURCE_DIR ] ; then
  echo "source dir '$SOURCE_DIR'  does not exists. exit"
  exit 1
fi

if [ ! -e $TARGET_DIR ] ; then
  echo "TARGET_DIR does not exists. exit"
  exit 1
fi

TARGET_DIR=$TARGET_DIR/$SNAPSHOT_DIR

rsync -av $SOURCE_DIR/ $TARGET_DIR --delete


