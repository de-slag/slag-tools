#!/bin/bash

source base-utils-stable.sh
source logging-utils-stable.sh

HOSTS_FILE_SRC=/etc/hosts
HOSTS_FILE_ORIG=/etc/hosts.orig

# at stable state this should be $HOSTS_FILE_SRC
HOSTS_FILE_TARGET=/etc/hosts.final


if [ -f $HOSTS_FILE_ORIG ] ; then
  log_error "An orig hostfile already exits. Please check and remove file before run again: $HOSTS_FILE_ORIG"
  exit 1
fi

cp $HOSTS_FILE_SRC $HOSTS_FILE_ORIG


