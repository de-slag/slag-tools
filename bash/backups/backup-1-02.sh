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

# function_cli-args.sh
function read_cli_args {
  for i in "$@"
  do
  case $i in

    -h|--help)
      echo "This script simply creates a gzipped tar of a directory into another for backup. To distinguish a timestamp is added to filename."
      echo "All options are mandatory."
      echo "usage: backup.sh [options]"
      echo
      echo "options:"
      echo "-s, --source-dir     directory what is backuped"
      echo "-t, --target-dir     directory where backup is stored"
      echo "-n, --name           name used for backup file"
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

    *)
     log "'read_cli_args' unknown option: '$i', skipped"
      ;;
  esac
  done
}

function write_log {
  local target_dir=$1
  local log_entry=$2
  echo "$HOSTNAME $log_entry" >> $target_dir/backup.log
}

function run_backup {
  local source_dir=$1
  local target_dir=$2
  local tech_name=$3
  local timestamp=$(date '+%Y-%m-%dT%H:%M:%S')
  cd $source_dir

  log_info "run backup from souce dir: '$source_dir' to target dir '$target_dir' with timestamp: '$timestamp' and name: '$tech_name'"

  local filename="$target_dir/$tech_name-$timestamp.tar.gz"

  log_info "filename: '$filename'" 
  
  if [ "$DEBUG" = true ] ; then
    tar -cvzf $filename * 
  else
    tar -czf $filename * 
  fi 
  local run_exit_code=$?

  if [ 0 -ne $run_exit_code ] ; then
    write_log $target_dir "$filename NOT successful"
    log_error "failed"
    exit 1
  fi
  write_log $target_dir "$filename SUCCSESSFUL" 
}

if [ -z $1 ] ; then
  read_cli_args "-h"
fi

read_cli_args "$@"
# end function_cli-args.sh
# end of generated section
log_debug "source dir: '$SOURCE_DIR'"
log_debug "target dir: '$TARGET_DIR'"
log_debug "name: '$NAME'"
run_backup $SOURCE_DIR $TARGET_DIR $NAME
log_info "all done!"

