#!/bin/bash

set -euo pipefail
#set -x

source logging-utils.sh
source base-utils.sh
source config-utils.sh

function ui {
  user_input "$1"
}

read_config_value vrt.guest.iso ~/slag-configurations/global.properties
ISO_DIR=$CONFIG_VALUE

echo
echo
echo
echo "### Install VM Wizard ###"

cd $ISO_DIR
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

read_config_value vrt.install.mac ~/slag-configurations/global.properties
MAC=$CONFIG_VALUE

read_config_value vrt.guest.images ~/slag-configurations/global.properties
IMAGES_DIR=$CONFIG_VALUE
echo "virt install..."
virt-install --connect qemu:///system -n $VM_NAME -r $RAM --vcpus=1 -f $IMAGES_DIR/$IMG_NAME.img -s $IMG_SIZE --vnc --cdrom $ISO --noautoconsole --os-type linux --accelerate --network=bridge:virbr0,model=virtio -m $MAC -k de
virsh undefine $VM_NAME
