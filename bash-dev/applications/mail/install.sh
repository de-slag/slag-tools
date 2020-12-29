#!/bin/bash
USER=slag-mail
PASSWORD=$1
APP_SUBDIR=$USER

function create_user {
  if [ -z $PASSWORD ] ;then echo "ERROR: no password" ;exit 1 ;fi
  echo "OK: password"

  if [ -e /home/$USER ] ;then echo "ERROR: user already exists: $USER"; exit 1;fi
  echo "OK: user not existing"

  useradd -m $USER
  echo -e "$PASSWORD\n$PASSWORD" | passwd $USER
}

function create_app_dir {
  local app_dir=/opt/$APP_SUBDIR
  mkdir $app_dir
  chown $USER:$USER $app_dir
}

function copy_cron {
  cp run-slag-mail.sh /etc/cron.hourly
}

set -x

if [[ $EUID -ne 0 ]]; then echo "This script must be run as root"; exit 1; fi

create_user
create_app_dir
copy_cron

echo "all done"
