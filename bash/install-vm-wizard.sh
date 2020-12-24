#!/bin/bash

set -euo pipefail
#set -x

source logging-utils.sh
source base-utils.sh
source config-utils.sh

function ui {
  user_input "$1"
}

clear
echo "### Install VM Wizard ###"

cd /mnt/vrt/iso
iso_list=$(ls -fA *.iso)
idx=0
for entry in $iso_list ; do
  echo "($idx) $entry"
  idx=$(expr $idx + 1)
done

ui "choose:"

SELECTION=$USER_INPUT
echo "you choosed: '$SELECTION'"

idx=0
SELECTED_ISO=
for entry in $iso_list ; do
  if [ $SELECTION -eq $idx ] ; then
    SELECTED_ISO=$entry
  fi
  idx=$(expr $idx + 1)
done
echo "you choosed iso: '$SELECTED_ISO'"

ui "enter a name for hdd-image (without '.img', also used for installation-vm):"
IMG_NAME=$USER_INPUT

DEFAULT_IMG_SIZE=8
ui "enter a size for hdd (default: $DEFAULT_IMG_SIZE):"
IMG_SIZE=
if [ -z $USER_INPUT ] ; then
  IMG_SIZE=$DEFAULT_IMG_SIZE
else
  IMG_SIZE=$USER_INPUT
fi

ISO=/mnt/vrt/iso/$SELECTED_ISO
RAM=1024

VM_NAME=INSTALL_$IMG_NAME
MAC=00:00:00:00:00:07

COMMAND="virt-install --connect qemu:///system -n $VM_NAME -r $RAM --vcpus=1 -f /mnt/vrt/images/$IMG_NAME.img -s $IMG_SIZE --vnc --cdrom $ISO --noautoconsole --os-type linux --accelerate --network=bridge:br0,model=virtio -m $MAC -k de"
echo $COMMAND

#TODO: complete script
exit 1
