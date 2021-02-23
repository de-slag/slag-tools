#!/bin/bash

source ~/slag-tools/bash/core-script.sh

readonly TS=$(date $TIMESTAMP_PATTERN)

log_debug "timestamp for current run is '$TS'"

function collect_data {
   this_host=$(cat /etc/hostname)
   log_debug "this host: '$this_host'"
   
   host_drives_config_key=healthstate.$this_host.drives
   read_config_value $host_drives_config_key
   host_drives=$CONFIG_VALUE
   if [ -z $host_drives ] ; then
     log_warn "no drives configured for host '$this_host' (config key: $host_drives_config_key)"
   fi
   log_info "found values for '$this_host': '$host_drives'"

   for drive in $host_drives ; do
     log_file_name=$healthstate_log_dir/healthstate-hdd-$TS-$drive.log

     smartctl --test=short -C /dev/$drive
     smartctl -l selftest /dev/sdc | grep "# 1\|# 2\|# 3\|# 4" > $log_file_name
   done
}
 

function assert_log_dir {
  read_config_value healthstate.log.dir
  local healthstate_log_dir=$CONFIG_VALUE
  mkdir_if_any $healthstate_log_dir
}

assert_user_root
assert_log_dir
collect_data

log_info "all done!"
