#!/bin/bash

source ~/slag-tools/bash/core-script.sh

readonly TS=$(date $TIMESTAMP_PATTERN)
readonly OUT_FILE_NAME_EXTENSION=smart-monitor.log

log_debug "started with ts $TS"

DEVICE=
LOG_DIR=
OUT_FILE=


function run_smart_monitor {
  smartctl -t short -C $DEVICE
  smartctl -l selftest $DEVICE > $OUT_FILE
}

function assert_preconditions {
  # device
  if [ ! -e $DEVICE ] ; then
    log_error "device not found '$DEVICE'"
    exit 1 
  fi

  # log directory
  if [ ! -d $LOG_DIR ] ; then
    log_error "device not found '$DEVICE'"
    exit 1 
  fi

}

function create_log_targets {
  device_for_filename=${DEVICE//\//_}

  OUT_FILE=$LOG_DIR/$TS-$device_for_filename-$OUT_FILE_NAME_EXTENSION
}

function print_help {
  echo "-l    --log-dir"
  echo "-d    --device"
  echo "      --help      prints this help"
}


for i in "$@"
do
case $i in
    -l=*|--log-dir=*)
      LOG_DIR="${i#*=}"
      shift # past argument=value
      ;;
    -d=*|--device=*)
      DEVICE="${i#*=}"
      shift # past argument=value
      ;;

    -h|--help)
      echo "usage bkp-create-backup.sh -p=/parent/of/source -s=source_dir -t=/path/to/backups"
      exit
      ;;
    *)
      log_warn "unknown option: '$i'"
      shift
      ;;
esac
done

assert_preconditions
create_log_targets
run_smart_monitor


log_info "all done"
