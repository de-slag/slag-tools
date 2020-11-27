#!/bin/bash

## TODO: Check if root 

apt-get install nfs-common

# create mount points for nfs
mkdir /mnt/data 
mkdir /mnt/logic
mkdir /mnt/backup 
mkdir /mnt/vrt
mkdir /mnt/backup_archive

# add nfs mounts to fstab 
cp /etc/fstab /etc/fstab.bak

function append_fstab {
  echo $1 >> /etc/fstab 
}

function append_nfs {
  local host=$1
  local path=$2
  local mntpoint=$3

  append_fstab "$host:$path/$mntpoint /mnt/$mntpoint nfs"
}

append_fstab ""
append_fstab "## BEGIN GENERATED SECTION"

append_nfs uranus /volume1 data
append_nfs uranus /volume1 logic
append_nfs uranus /volume1 backup
append_nfs uranus /volume1 vrt
append_nfs jupiter /media/raid0 backup_archive

append_fstab "## END GENERATED SECTION"

# create a minutely cron
mkdir /etc/cron.minutely
cp /etc/crontab /etc/crontab.bak
echo "* * * * * root    cd / && run-parts --report /etc/cron.minutely" >> /etc/crontab 

# create a run minutely mount all
echo "mount -a" > /etc/cron.minutely/mount-all
chmod +x /etc/cron.minutely/mount-all 



echo "all done!"
