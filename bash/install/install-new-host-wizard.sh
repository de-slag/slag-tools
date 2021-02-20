#!/bin/bash

source ~/slag-tools/bash/core-script.sh

DRY_RUN=true

function run_cmd {
  local cmd="$1"
  if [ "true" == $DRY_RUN ] ; then
    echo "DRY RUN: $cmd"
    return
  fi
  $(cmd)
}

HOST_LOCATION=
function select_host_location {
  read_config_value host.locations
  supported_host_locations=$CONFIG_VALUE

  user_select_item "$supported_host_locations"
  HOST_LOCATION=$SELECTED_ITEM

  log_info "selected location: $HOST_LOCATION"
}

function install_nfs {
  if [ -z $HOST_LOCATION ] ; then log_warn "no host location selected, skip install nfs" ; return ; fi
  log_debug "install nfs for location '$HOST_LOCATION'..."

  read_config_value host.location.$HOST_LOCATION.nfshost.default
  nfshost_default_name=$CONFIG_VALUE
  log_debug "default nfshost of location '$HOST_LOCATION' ist '$nfshost_default_name'"
  assert_not_null nfshost-name $nfshost_default_name

  read_config_value host.nfs.default.mountpoint.parent
  nfs_mountpoint_parent=$CONFIG_VALUE
  assert_not_null nfs_mountpoint_parent $nfs_mountpoint_parent
  log_debug "nfs_mountpoint_parent: '$nfs_mountpoint_parent'"

  read_config_value host.nfs.ids
  nfs_ids=$CONFIG_VALUE
  assert_not_null nfs_ids $nfs_ids
  log_debug "nfs_ids: '$nfs_ids'"
  
  for mountpoint in $nfs_ids ; do
    local mountpoint_path=$nfs_mountpoint_parent/$mountpoint
    echo "create dir: '$mountpoint_path'"
    run_cmd "mkdir -p $mountpoint_path"
  done

  ## install nfs entries

}

if [ "true" != $DRY_RUN ] ; then
  assert_user_root
fi
select_host_location
install_nfs


log_info "all done!"