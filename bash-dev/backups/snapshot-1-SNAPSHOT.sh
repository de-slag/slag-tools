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

  # FIXME
  log_error "the following command deletes also the .lock file"
  exit 1

  rsync -av $source_dir/ $target_dir --delete

}

function clear_dirs_no_backup {
  local target_dir=$1

  log_error "'clear_dirs_no_backup', not implemented yet"

  ## TODO traverse through all directories and subdirectories to clear ones that contains a '.no-backup'-file and leave a file 'NO_BACKUP.txt' with a short description
}

log_debug "source dir: '$SOURCE_DIR'"
log_debug "target dir: '$TARGET_DIR'"
log_debug "name: '$NAME'"

readonly LOCK_FILE="$TARGET_DIR/.lock"
readonly DONE_FILE="$TARGET_DIR/snapshot.done"

# assert target dir exists
if [ ! -d $TARGET_DIR ] ; then
  log_error "target dir does not exist '$TARGET_DIR'"
  exit 1
fi

# assert lock file does not exist
if [ -f $LOCK_FILE ] ; then
  log_error "lock file exists: '$LOCK_FILE'"
  exit 1
fi

# remove done file if any
if [ -f $DONE_FILE ] ; then
  rm $DONE_FILE
  log_info "done-file removed"
fi

# create lock file
echo "snapshot" > $LOCK_FILE

run_backup $SOURCE_DIR $TARGET_DIR $NAME

# start clear dirs if any
if [[ "$NO_BACKUP" == true ]] ; then
  clear_dirs_no_backup $TARGET_DIR
fi

touch $DONE_FILE
rm $LOCK_FILE

log_info "all done!"

