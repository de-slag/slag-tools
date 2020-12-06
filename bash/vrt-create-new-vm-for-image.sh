#!/bin/bash
# v2

## MACHINE SECTION

# Lubuntu

NAME=lubuntu-20.04-desktop
MAC=00:00:00:00:00:08

# Server

#NAME=ubuntu-20.04-server
#MAC=00:00:00:00:00:07


## ISO SECTION

# Lubuntu
ISO_DL=http://cdimage.ubuntu.com/lubuntu/releases/20.04/release/lubuntu-20.04.1-desktop-amd64.iso
ISO=lubuntu-20.04.1-desktop-amd64.iso

# Server
#ISO_DL=https://ftp.halifax.rwth-aachen.de/ubuntu-releases/20.04/ubuntu-20.04.1-live-server-amd64.iso
#ISO=$VRT_ISO_DIR/ubuntu-20.04.1-live-server-amd64.iso


## COMMON SECTION

VRT_DIR=/home/vrt-test
VRT_ISO_DIR=$VRT_DIR/iso
VRT_IMG_DIR=$VRT_DIR/img
IMG=$VRT_IMG_DIR/$NAME.img




function log {
  echo $1
}

if [ ! -d $VRT_DIR ] ; then
  log "VRT_DIR not found"
  exit 1
fi

if [ ! -d $VRT_ISO_DIR ] ; then
  log "create iso dir: $VRT_ISO_DIR"
  mkdir $VRT_ISO_DIR
fi


if [ ! -d $VRT_IMG_DIR ] ; then
  log "create img dir: $VRT_IMG_DIR"
  mkdir $VRT_IMG_DIR
fi

if [ ! -f $VRT_ISO_DIR/$ISO ] ; then
  log "download img '$ISO_DL' to file: $VRT_ISO_DIR/$ISO"
  # wget $ISO_DL --output-document=DATEI 
  curl $ISO_DL --output $VRT_ISO_DIR/$ISO
fi

# kernel panic at 512 
RAM=1024

virt-install --connect qemu:///system -n $NAME -r $RAM --vcpus=1 -f $IMG -s 12 --vnc --cdrom $VRT_ISO_DIR/$ISO --noautoconsole --os-type linux --accelerate  -m $MAC -k de --vnc 
#--network=bridge:br0,model=virtio

