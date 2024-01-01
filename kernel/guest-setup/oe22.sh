#!/usr/bin/env bash
set -E -e -u -o pipefail

yum install -y audit-libs-devel binutils-devel bison \
	elfutils-devel elfutils-libelf-devel flex openssl-devel

yum install -y git gcc

cd kernel
make -j32 && sudo make install -j32 && sudo make modules_install -j32
dracut --regenerate-all -f
# 只是更新一个
# dracut --kver $(uname -r) --force

# ubuntu 的命令
# sudo update-initramfs -c -k all

grub2-mkconfig -o /etc/grub2-efi.cfg
grub2-mkconfig -o /etc/grub2.cfg
# ubuntu 的命令
# sudo update-grub

# 如果只是一个模块
make M=./arch/x86/kvm/ modules -j32
make M=./arch/x86/kvm/ modules_install
sudo update-initramfs -c -k "$(uname -r)" # 当然如果这个如果是启动的时候需要的包
reboot
