#!/bin/bash

source ~/slag-tools/bash/core-script.sh

function print_help {
  echo "synthax: run-snapshot+backup.sh [options]"
  echo ""
  echo "options:"
  echo "-h  --help              print this help"
  echo "-c  --config-file       config properties file"
  echo ""
  echo "example: run-snapshot+backup.sh -c=/path/to/config.properties"
}

for i in "$@" ; do
  case $i in
    -c=*|--config-file=*)
      THIS_CONFIG_FILE="${i#*=}"
      shift
      ;;
    --help)
      print_help
      exit 0
      ;;
    *)
      log_warn "unknown option: $i"
    ;;
  esac
done

set +u
if [ -z $THIS_CONFIG_FILE ] ; then log_error "config file not setted" ; exit 1 ; fi
set -u
if [ ! -f $THIS_CONFIG_FILE ] ; then log_error "file not found '$THIS_CONFIG_FILE'" ; exit 1 ; fi
CONFIG_FILE=$THIS_CONFIG_FILE

read_config_value data.parent.dir
DATA_PARENT_DIR=$CONFIG_VALUE

read_config_value snapshot.dir
SNAPSHOT_DIR=$CONFIG_VALUE

read_config_value backup.dir
BACKUP_DIR=$CONFIG_VALUE

if [ -z $DATA_PARENT_DIR ] ; then log_error "not setted 'DATA_PARENT_DIR'" ; exit 1 ; fi
if [ -z $SNAPSHOT_DIR ] ; then log_error "not setted 'SNAPSHOT_DIR'" ; exit 1 ; fi
if [ -z $BACKUP_DIR ] ; then log_error "not setted 'BACKUP_DIR'" ; exit 1 ; fi

if [ ! -d $DATA_PARENT_DIR ] ; then log_error "directory not found '$DATA_PARENT_DIR'" ; exit 1 ; fi
if [ ! -d $SNAPSHOT_DIR ] ; then log_error "directory not found '$SNAPSHOT_DIR'" ; exit 1 ; fi
if [ ! -d $BACKUP_DIR ] ; then log_error "directory not found '$BACKUP_DIR'" ; exit 1 ; fi



read_config_value data.dirs
DATA_DIRS=$CONFIG_VALUE

for data_dir in $DATA_DIRS ; do
  rm -Rf $SNAPSHOT_DIR/*

  data_dir_path=$DATA_PARENT_DIR/$data_dir
  if [ ! -d $data_dir_path ] ; then log_warn "directory not found '$data_dir_path'. continue" ; continue ; fi

  log_info "processing: $data_dir_path"
  ~/slag-tools/bash/bkp-create-snapshot.sh -p=$DATA_PARENT_DIR -s=$data_dir -t=$SNAPSHOT_DIR
  ~/slag-tools/bash/bkp-cleanup-traverse-not-to-backup.sh -d=$data_dir_path
  log_debug "data dir '$data_dir'"
  log_debug "backup dir '$BACKUP_DIR'"
  log_debug "backup dir '$BACKUP_DIR'"
  ~/slag-tools/bash/bkp-create-backup.sh -p=$SNAPSHOT_DIR/ -t=$BACKUP_DIR -s=$data_dir
  
done


log_info "all done"