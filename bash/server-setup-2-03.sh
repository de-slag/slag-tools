
#!/bin/bash
clear

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

echo "#### assert some directories..."
echo

assert_dir /root/logic/minutely
assert_dir /root/logic/at-reboot
assert_dir /root/logic/daily
assert_dir /root/logic/weekly
assert_dir /root/data/logs

echo
echo "#### now add the following lines to root's crontab"
echo
echo "@reboot    for f in /root/logic/at-reboot/*.sh; do bash "$f" -H ;done >> /root/data/logs/at-reboot.log 2>&1"
echo "* * * * *  for f in /root/logic/minutely/*.sh; do bash "$f" -H ;done >> /root/data/logs/minutely.log 2>&1"
echo "0 5 * * *  for f in /root/logic/daily/*.sh; do bash "$f" -H ;done >> /root/data/logs/daily.log 2>&1"
echo "0 0 * * 1  for f in /root/logic/weekly/*.sh; do bash "$f" -H ;done >> /root/data/logs/weekly.log 2>&1"
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

