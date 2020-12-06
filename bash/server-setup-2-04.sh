#!/bin/bash

clear

echo "This scipt is supposed to set up a linux server. It should can be executed mutiple times, also future versions. It only create things, it does not cleans up things from further versions."
echo
echo "hit ENTER to continue"
read




function assert_dir {
  if [ -z $1 ] ; then
    echo "parameter not setted, break"
    return
  fi

  if [ -d $1 ] ; then
    echo "dir '$1' already exists, break"
    return
  fi

  echo "create dir: $1"
  mkdir $1
}

function create_00_script {
  echo "'create_00_script' not implemented yet!"
  echo "create 00_$1.sh in '/root/logic/$1' on your own"
}

function print_crontab_entry {
  local dir=$1
  local start_at=$2

  echo "$start_at  cd /root/logic/$dir  && for f in *.sh; do bash \"\$f\" -H ;done >> /root/data/logs/$dir.log 2>&1"
}

echo "#### assert some directories..."
echo

assert_dir /root/logic/minutely/
assert_dir /root/logic/at-reboot/
assert_dir /root/logic/daily/
assert_dir /root/logic/weekly/
assert_dir /root/data/logs/

echo
echo "#### now add the following lines to root's crontab"
echo
print_crontab_entry minutely "* * * * *"
print_crontab_entry daily  "0 5 * * *"
print_crontab_entry weekly "0 0 * * 1"
print_crontab_entry at-reboot "@reboot"

echo
echo "#### when done, hit ENTER to continue."
read

create_00_script at-reboot
create_00_script minutely
create_00_script daily
create_00_script weekly

echo "#### when done, hit ENTER to continue."
read

echo "### all done"

