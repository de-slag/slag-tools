#!/bin/bash

source ~/slag-tools/utils/base-utils-stable.sh
source ~/slag-tools/utils/logging-utils-stable.sh

CURRENT_HOSTNAME=$(cat /etc/hostname)
TARGET_HOSTNAME=$1
TIMESTAMP=$(date +%s)

SED_STRING='s/$CURRENT_HOSTNAME/$TARGET_HOSTNAME/'


function create_backups {
  cp /etc/hostname /etc/hostname.bak.$TIMESTAMP
  cp /etc/hosts /etc/hosts.bak.$TIMESTAMP
}

function sed_hostname {
  sed '$SED_STRING /etc/hostname
}

function sed_hosts {
  sed '$SED_STRING /etc/hosts
}

log_info "set hostname from '$CURRENT_HOSTNAME' to '$TARGET_HOSTNAME'"

exit 0

create_backups
sed_hosts
sed_hostname
hostname -F /etc/hostname
reboot
