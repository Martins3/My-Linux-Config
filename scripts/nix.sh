#!/usr/bin/env bash

QEMU=/home/maritns3/core/kvmqemu/build/x86_64-softmmu/qemu-system-x86_64
# QEMU=qemu-system-x86_64
# KERNEL=/home/maritns3/core/ubuntu-linux/arch/x86/boot/bzImage
ISO=/home/maritns3/arch/nixos-gnome-21.11.334247.573095944e7-x86_64-linux.iso

disk_img=/home/maritns3/hack/vm/nix.qcow2

if [[ ! -f $disk_img ]]; then
  qemu-img create -f qcow2 "$disk_img" 100G
  # $QEMU -cdrom "$ISO" -hda "$disk_img" -enable-kvm -m 8G -smp 8 -cpu host
  qemu-system-x86_64 -enable-kvm -m 8G -boot d -cdrom $ISO -hda ${disk_img}
  exit 0
fi

# qemu-system-x86_64 -enable-kvm -m 8192 -boot d -cdrom $ISO -hda ${disk_img}
$QEMU -hda ${disk_img} -enable-kvm -cpu host -m 8G -smp 8 -display gtk,window-close=off -vga virtio
# qemu-system-x86_64 -enable-kvm -m 8192 -kernel ${KERNEL} -drive file=${disk_img},format=qcow2  -append "root=/dev/sda1"
