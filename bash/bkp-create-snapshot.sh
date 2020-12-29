#!/bin/bash
for i in "$@"
do
case $i in
    -p=*|--parent-dir-to-snapshot=*)
    SNAPSHOT_PARENT_DIR="${i#*=}"
    shift # past argument=value
    ;;
    -w=*|--workdir=*)
    WORKDIR="${i#*=}"
    shift # past argument=value
    ;;
    -s=*|--dir-to-snapshot=*)
    SNAPSHOT_DIR="${i#*=}"
    shift # past argument=value
    ;;
    -h|--help)
    echo "usage bkp-create-snapshot.sh -p=/parent/of/source -s=source_dir -w=/path/to/snapshots"
    *)
          # unknown option
    ;;
esac
done

if [ -z $SNAPSHOT_PARENT_DIR ] ; then
  echo "parent-dir-to-snapshot not setted. exit"
  exit 1
fi

if [ -z $WORKDIR ] ; then
  echo "workdir not setted. exit"
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

if [ ! -e $WORKDIR ] ; then
  echo "workdir does not exists. exit"
  exit 1
fi

TARGET_DIR=$WORKDIR/$SNAPSHOT_DIR

rsync -av $SOURCE_DIR/ $TARGET_DIR --delete


