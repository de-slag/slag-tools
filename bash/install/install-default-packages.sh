#!/bin/bash

source ~/slag-tools/bash/core-script.sh

assert_user_root

if [ ! -e /etc/debian_version ] ; then
  log_error "only debian based systems are supported"
  exit 1
fi

read_config_value install.packages.debian
PACKAGES_TO_BE_INSTALLED=$CONFIG_VALUE

for package in $PACKAGES_TO_BE_INSTALLED ; do
  echo "install $package"
  apt-get install package
done

log_info "all done"