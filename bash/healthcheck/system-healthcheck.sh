#!/bin/bash

source ~/slag-tools/bash/core-script.sh

read_config_value lhc.logcache
LHC_LOGDIR=$CONFIG_VALUE

read_config_value lhc.report.all
REPORT_ALL=$CONFIG_VALUE

read_config_value lhc.report.file
REPORT_FILE=$CONFIG_VALUE

HOSTNAME=$(cat /etc/hostname)

function assert_lhclogdir {
  if [ -z $LHC_LOGDIR ] ; then
    log_warn "not configured: lhc.logdir"
    exit 0
  fi

  if [ ! -d $LHC_LOGDIR ] ; then
    log_warn "dir not found: $LHC_LOGDIR"
    exit 0
  fi  
}

FILES_LIST=
function get_list_files {
  cd $LHC_LOGDIR
  FILES_LIST=$(ls)
}

LOGGED_TESTS=""
function append_test {
  test_to_append=$1
  LOGGED_TESTS="$LOGGED_TESTS\n$test_to_append"
}


TOTAL_RESULT=OK
ANALYZED_TESTS=0
SUCCEED_TESTS=0
function analyze_files {
  for file_name in $FILES_LIST ; do
    log_debug "$file_name"
    line=$(head -n 1 $file_name)
    log_debug "analyze '$line'..."
    ANALYZED_TESTS=$(($ANALYZED_TESTS + 1))
    ok_prefix="[ OK ]"
    if [[ "$line" == "$ok_prefix"* ]] ; then
      log_debug "test ok"
      SUCCEED_TESTS=$(($SUCCEED_TESTS + 1))
      if [ "true" == "$REPORT_ALL" ] ; then
        append_test "$line"     
      fi
      continue
    fi
    log_debug "test NOT ok: $line"
    TOTAL_RESULT=FAILED
    append_test "$line"
  done
}

function generate_report {
  ts=$(date "+%Y-%m-%d %H:%M:%S")
  echo "[ $TOTAL_RESULT ] System Health Check: $ts -'$HOSTNAME'- tests ok [$SUCCEED_TESTS/$ANALYZED_TESTS]"  > $REPORT_FILE
  printf "$LOGGED_TESTS"                                                                                    >> $REPORT_FILE
  echo ""                                                                                                   >> $REPORT_FILE
}

assert_lhclogdir
get_list_files
log_debug "$FILES_LIST"
analyze_files
generate_report

log_info "all done!"

