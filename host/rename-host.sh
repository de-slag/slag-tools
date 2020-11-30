#!/bin/bash

source ~/slag-tools/utils/base-utils-stable.sh
source ~/slag-tools/utils/logging-utils-stable.sh

TARGET_HOSTNAME=$1
TIMESTAMP=$(date +%s)

function create_backups {
  cp /etc/hostname /etc/hostname.bak.$TIMESTAMP
  cp /etc/hosts /etc/hosts.bak.$TIMESTAMP
}


