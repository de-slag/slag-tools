#!/bin/bash

source logging-utils.sh
source config-utils.sh

TARGET_FILE_CONTENT=


# there is pureposeyl only one "/" after ":" to have a more common notation at config file, i.e. '/path/to/share' instead of 'path/to/share'
BASE_STRING="§host:/§share §mountpoint nfs §rights 0 0"

function create_mountpoint {
  local area=$1
  log_info "assert mountpoint for area '$area'"
  read_config_value nfs.$area.mountpoint ~/slag-configurations/global.properties
  local mountpoint="$CONFIG_VALUE"

  if [ ! -e $mountpoint ] ; then
    log_debug "create mountpoint '$mountpoint'"
    mkdir $mountpoint
  else
    log_debug "mountpoint '$mountpoint' already exists"
  fi
}

function create_mountpoints {
  read_config_value nfs.areas ~/slag-configurations/global.properties
  IN="$CONFIG_VALUE"

  data_areas=$(echo $IN | tr ";" "\n")

  for area in $data_areas
  do
    create_mountpoint $area
  done
}


function append_to_content {
  TARGET_FILE_CONTENT="$TARGET_FILE_CONTENT$1\n"
}

function create_entries {
  read_config_value nfs.areas ~/slag-configurations/global.properties

  IN="$CONFIG_VALUE"

  data_areas=$(echo $IN | tr ";" "\n")

  for area in $data_areas
  do
    create_entry_for_area $area
  done
}

function create_entry_for_area {
  log_info "area: '$area'"
  host_property="nfs.$area.host"
  log_debug "host property: '$host_property'"
  
  read_config_value nfs.$area.host ~/slag-configurations/global.properties
  host="$CONFIG_VALUE"

  read_config_value nfs.$area.share ~/slag-configurations/global.properties
  share="$CONFIG_VALUE"

  read_config_value nfs.$area.mountpoint ~/slag-configurations/global.properties
  mountpoint="$CONFIG_VALUE"

  read_config_value nfs.$area.rights ~/slag-configurations/global.properties
  rights="$CONFIG_VALUE"

  log_debug "host: [$host]"
  log_debug "share: [$share]"
  log_debug "mountpoint: [$mountpoint]"
  log_debug "rights: [$rights]"

  host_replaced="${BASE_STRING/§host/$host}"
  share_replaced="${host_replaced/§share/$share}"
  mountpoint_replaced="${share_replaced/§mountpoint/$mountpoint}"
  all_replaced="${mountpoint_replaced/§rights/$rights}"

  log_debug "all replaced: '$all_replaced'"
  append_to_content "$all_replaced"
}

function append_to_fstab {
  local ts=$(date '+%Y-%m-%d_%H-%M-%S')
  local fstab_backup_name="/etc/fstab.bak-$ts"
  log_debug "fstab backup name: '$fstab_backup_name'"

  log_info "backup '/etc/fstab' to '$fstab_backup_name'"
  cp /etc/fstab $fstab_backup_name

  log_info "append 'etc/fstab.to-append' to '/etc/fstab'"
  echo "#[SLAG] begin auto created section" >> /etc/fstab
  cat /etc/fstab.to-append >> /etc/fstab
}

PACKAGES="nfs-common"
function install_packages {
  log_debug "install packages: '$PACKAGES'"
  apt-get -y install "$PACKAGES"
}

function mount_all {
  log_debug "mount all"
  mount -a
}

install_packages
create_mountpoints
create_entries

printf "$TARGET_FILE_CONTENT" > /etc/fstab.to-append

append_to_fstab
mount_all

log_info "all done"


