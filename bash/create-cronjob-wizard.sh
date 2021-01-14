#!/bin/bash

source ~/slag-tools/bash/core-script.sh

readonly BASE_DIR=~/slag-tools/bash
readonly CRON_BASE_DIR=/etc

clear

readonly TS=$(date +%s)

USER_INPUT=
function ui {
  printf "$1: "
  read USER_INPUT
}

FILES=
function find_relevant_files {

  local RAW_FILE_LIST=$('ls' $BASE_DIR)
  log_debug "raw files-list: $RAW_FILE_LIST"

  local FILE_LIST=""
  for file in $RAW_FILE_LIST ; do
    file_path=$BASE_DIR/$file
    log_trace "checking $file_path..."

    if [ ! -f $file_path ] ; then
      log_debug "is not a normal file: '$file_path', skipping."
      continue
    fi

    if [[ $file == utl-* ]] ; then
      log_debug "is a utils-script: '$file_path', skipping."
      continue 
    fi

    if [[ $file == *-wizard.sh ]] ; then
      log_debug "is a wizard-script: '$file_path', skipping."
      continue 
    fi

    if [[ $file == core-* ]] ; then
      log_debug "is a core-script: '$file_path', skipping."
      continue 
    fi

    if [[ $file == ins-* ]] ; then
      log_debug "is a install-script: '$file_path', skipping."
      continue 
    fi

    FILE_LIST="$FILE_LIST$file\n"
  done

  log_debug "file list: $FILE_LIST"

  for file in $FILE_LIST ; do
    log_debug "relevant script: $file"
  done
  FILES=$FILE_LIST
}


SCRIPT=
function choose_script {
  msg="$FILES\nwhich script?"
  ui "$msg"
  local choosen_script=$USER_INPUT
  if [ ! -e $BASE_DIR/$choosen_script ] ; then
    echo "scritp does not extists: '$BASE_DIR/$choosen_script'. exit."
    exit 1
  fi
  echo "ok. your choice: '$choosen_script'"
  SCRIPT=$choosen_script
}

PURE_SCRIPT_NAME=
function extract_pure_script_name {
  PURE_SCRIPT_NAME=${SCRIPT%.sh}
}

CRON_TYPE=
function choose_cron_type {
  ui "(m)onthly\n(w)eekly\n(d)aily\n(h)ourly\nm(i)nutely\nwhich cronjob type?"
  local selected_crontype=$USER_INPUT
  case "$selected_crontype" in
    m) CRON_TYPE=MONTHLY ;;
    w) CRON_TYPE=WEEKLY ;;
    d) CRON_TYPE=DAILY ;;
    h) CRON_TYPE=HOURLY ;;
    i) CRON_TYPE=MINUTELY ;;
    *) log_error "invalid cron type: '$selected_crontype'" ; exit ;;
  esac
  assert_not_null $CRON_TYPE crontype
}

LOG_TARGET=
function choose_log_target {
  read_config_value logging.default.target.dir

  local default_log_target=
  if [ -z $CONFIG_VALUE ] ; then
    default_log_target=/var/log/slag/$PURE_SCRIPT_NAME.log
  else
    default_log_target=$CONFIG_VALUE/$PURE_SCRIPT_NAME.log
  fi

  ui "log target (default: '$default_log_target')?"
  if [ -z $USER_INPUT ] ; then
    LOG_TARGET=$default_log_target
    return
  else 
    LOG_TARGET=$USER_INPUT
  fi
  log_debug "test log target: $LOG_TARGET..."
  touch $LOG_TARGET
  log_debug "test log target: $LOG_TARGET. ok."
}

PARAMETERS=
function select_parameters {
  ui "select parameters"
  PARAMETERS=$USER_INPUT
}

TMP_SCRIPT_NAME=
function create_tmp_script {
   TMP_SCRIPT_NAME=/tmp/$TS-$PURE_SCRIPT_NAME
   echo "#!/bin/bash"                                    > $TMP_SCRIPT_NAME
   echo "$BASE_DIR/$SCRIPT $PARAMETERS &>> $LOG_TARGET" >> $TMP_SCRIPT_NAME
}

TARGET_SCRIPT_NAME=
function determine_target_script_name {
  local cron_dir_part=

  case "$CRON_TYPE" in
    MONTHLY) cron_dir_part=monthly ;;
    WEEKLY) cron_dir_part=weekly ;;
    DAILY) cron_dir_part=daily ;;
    HOURLY) cron_dir_part=hourly ;;
    MINUTELY) cron_dir_part=minutely ;;
    *) log_error "not supported cront type: '$CRON_TYPE'" ; exit ;;
  esac
  
  local interim_target_script_name=$CRON_BASE_DIR/cron.$cron_dir_part/$PURE_SCRIPT_NAME
  if [ ! -e $interim_target_script_name ] ; then
    TARGET_SCRIPT_NAME=$interim_target_script_name
    return
  fi
  ui "intended target file already exists '$interim_target_script_name'. choose another one or leve blank for overwriting"
  if [ -z $USER_INPUT ] ; then
    TARGET_SCRIPT_NAME=$interim_target_script_name
    return
  fi

  TARGET_SCRIPT_NAME=$USER_INPUT

}

COPY_CMD=
function create_copy_cmd {
  COPY_CMD="cp $TMP_SCRIPT_NAME $TARGET_SCRIPT_NAME"
}

function final_user_check {

  echo "final script:"
  echo "-----"
  cat $TMP_SCRIPT_NAME
  echo "-----"
  echo "copy cmd: '$COPY_CMD'"
  echo "-----"

  ui "is this ok? (yn)"
  local is_ok=$USER_INPUT
  if [ "y" != "$is_ok" ] ; then
    echo "you selected 'not ok'. exit."
    exit 0
  fi
  log_debug "user selected final check ok"
}

function install_crontab_script {
  $($COPY_CMD)
  chmod +x $TARGET_SCRIPT_NAME
}


find_relevant_files
choose_script
select_parameters
extract_pure_script_name
choose_cron_type
choose_log_target
create_tmp_script
determine_target_script_name
create_copy_cmd


final_user_check
install_crontab_script



