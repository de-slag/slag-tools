#!/bin/bash
IMG=/home/vrt-test/virt-test-11-28.img
ISO=/home/vrt-test/ubuntu-20.04.1-live-server-amd64.iso
virt-install --connect qemu:///system -n foo -r 1024 --vcpus=1 -f $IMG -s 12 --vnc --cdrom $ISO --noautoconsole --os-type linux --accelerate  -m 00:00:00:00:00:07 -k de --vnc 
#--network=bridge:br0,model=virtio
