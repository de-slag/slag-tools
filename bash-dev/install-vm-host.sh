#!/bin/bash

function ui_out {
  echo "$1"
  echo "hit ENTER to continue"
  read
}

ui_out "request admin rights..."
sudo -s

ui_out "Verify kvm installation..."
kvm-ok
ui_out "...expect output below like 'INFO: /dev/kvm exists KVM acceleration can be used'"

ui_out "install qemu-kvm libvirt-bin virtinst bridge-utils cpu-checker"
apt-get install qemu-kvm libvirt-bin virtinst bridge-utils cpu-checker

ui_out "assert start libvertd service..."
systemctl enable libvirtd
systemctl start libvirtd

ui_out "list all vms..."
virsh list --all




