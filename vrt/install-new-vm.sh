#!/bin/bash
# v2
IMG=/home/vrt-test/virt-test-11-28.img
ISO=/home/vrt-test/ubuntu-20.04.1-live-server-amd64.iso
NAME=foo

# kernel panic at 512 
RAM=1024

virt-install --connect qemu:///system -n $NAME -r $RAM --vcpus=1 -f $IMG -s 12 --vnc --cdrom $ISO --noautoconsole --os-type linux --accelerate  -m 00:00:00:00:00:07 -k de --vnc 
#--network=bridge:br0,model=virtio
