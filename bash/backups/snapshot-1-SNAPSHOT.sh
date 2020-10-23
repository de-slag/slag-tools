#/bin/bash
if [ "$1" == "TRACE" ] ; then
  set -x
  TRACE=true
  DEBUG=true
  shift
  echo "TRACE enabled"
fi

if [ "$1" == "DEBUG" ] ; then
  DEBUG=true
  shift
  echo "DEBUG enabled"
fi

source function-logging.sh

function read_cli_args {
  for i in "$@"
  do
  case $i in

    -h|--help)
      echo "This script simply creates a snapshot copy directory into another."
      echo "Options s,t, and n are mandatory."
      echo "usage: backup.sh [options]"
      echo
      echo "options:"
      echo "-s, --source-dir     directory what is backuped"
      echo "-t, --target-dir     directory where backup is stored"
      echo "-n, --name           name used for backup file"
      echo "-b, --no-backup      clears all directories that contains a '.no-backup' file"
      echo
      echo "supports 'DEBUG' or 'TRACE' as first parameter to show detailed information"
      exit 0
      ;;

    -s=*|--source-dir=*)
      SOURCE_DIR="${i#*=}"
      shift
      ;;
    -t=*|--target-dir=*)
      TARGET_DIR="${i#*=}"
      shift
      ;;
    -n=*|--name=*)
      NAME="${i#*=}"
      shift
      ;;
    -b|--no-backup)
      NO_BACKUP=true
      shift
      ;;

    *)
      log "'read_cli_args' unknown option: '$i', skipped"
      ;;
  esac
  done
}

if [ -z $1 ] ; then
  read_cli_args "-h"
fi

read_cli_args "$@"

function run_backup {
  local source_dir=$1
  local target_dir=$2
  local name=$3

  log_error "'run_backup', not implemented yet"

  ## TODO: do a hard 1:1 snapshot using rsync
}

function clear_dirs_no_backup {
  local target_dir=$1

  log_error "'clear_dirs_no_backup', not implemented yet"

  ## TODO traverse through all directories and subdirectories to clear ones that contains a '.no-backup'-file and leave a file 'NO_BACKUP.txt' with a short description
}

log_debug "source dir: '$SOURCE_DIR'"
log_debug "target dir: '$TARGET_DIR'"
log_debug "name: '$NAME'"

## TODO: assert no backup.lock file in target dir, otherwise error and EXIT 1
## TODO: echo "snapshot" to target-dir .lock

run_backup $SOURCE_DIR $TARGET_DIR $NAME

if [[ "$NO_BACKUP" == true ]] ; then
  clear_dirs_no_backup $TARGET_DIR
fi

## TODO: touch a file: snapshot.done
## TODO: remove .lock

log_info "all done!"

