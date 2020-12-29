#!/bin/bash

sudo apt-get install virtinst libvirt-bin
virsh connect qemu:///system 
