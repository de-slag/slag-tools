#!/bin/bash
set -euo pipefail

for i in "$@"
do
case $i in
    -p=*|--source-parent-dir=*)
      BACKUP_PARENT_DIR="${i#*=}"
      shift # past argument=value
      ;;
    -t=*|--target-dir=*)
      TARGET_DIR="${i#*=}"
      shift # past argument=value
      ;;
    -s=*|--source-dir=*)
      DIR_NAME="${i#*=}"
      shift # past argument=value
      ;;
    -h|--help)
      echo "usage bkp-create-backup.sh -p=/parent/of/source -s=source_dir -t=/path/to/backups"
      exit
      ;;
    *)
      # unknown option
      ;;
esac
done

function run_backup {
  local source_dir=$1
  local target_dir=$2
  local tech_name=$3
  local timestamp=$(date '+%Y-%m-%d_%H-%M-%S')
  cd $source_dir

  echo "run backup from souce dir: '$source_dir' to target dir '$target_dir' with timestamp: '$timestamp' and name: '$tech_name'"

  local filename_base="$target_dir/$tech_name-$timestamp"
  local filename="$filename_base.tar.gz"

  echo "filename: '$filename'"

  tar -czvf $filename *

  local run_exit_code=$?

  if [ 0 -ne $run_exit_code ] ; then
    echo $target_dir "$filename NOT successful"
    echo "failed"
    exit 1
  fi 
  echo $target_dir "$filename SUCCSESSFUL"
  touch "$filename_base.done"
}

run_backup $BACKUP_PARENT_DIR $TARGET_DIR $DIR_NAME
