#!/bin/bash

set -euxo pipefail

TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')

cp /etc/fstab /etc/fstab.bak-$TIMESTAMP
if [ ! -e /etc/fstab.orig ] ; then
  cp /etc/fstab /etc/fstab.orig
fi

mkdir /mnt/logic
mkdir /mnt/backup
mkdir /mnt/vrt
mkdir /mnt/backup_archive
mkdir /mnt/tmp
mkdir /mnt/data

echo "" 
echo "" 
echo "# 2020-12-datamig added: $TIMESTAMP"                                                             >> /etc/fstab
echo "# original file: /etc/fstab.orig"                                                                >> /etc/fstab
echo ""                                                                                                >> /etc/fstab
echo "jupiter.speedport.ip:/media/raid_a/data            /mnt/data            nfs defaults,nofail 0 9" >> /etc/fstab
echo "jupiter.speedport.ip:/media/raid_a/logic           /mnt/logic           nfs defaults,nofail 0 9" >> /etc/fstab
echo "jupiter.speedport.ip:/media/raid_a/backup          /mnt/backup          nfs defaults,nofail 0 9" >> /etc/fstab
echo "jupiter.speedport.ip:/media/raid_a/vrt             /mnt/vrt             nfs defaults,nofail 0 9" >> /etc/fstab
echo "jupiter.speedport.ip:/media/raid_a/backup_archive  /mnt/backup_archive  nfs ro,nofail 0 9"       >> /etc/fstab
echo "jupiter.speedport.ip:/media/raid_a/tmp             /mnt/tmp             nfs defaults,nofail 0 9" >> /etc/fstab

echo "all added. next: mount all"
echo "hit ENTER"
read
mount -a

