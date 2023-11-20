#!/usr/bin/env bash
set -E -e -u -o pipefail

yum install -y audit-libs-devel binutils-devel bison \
	elfutils-devel elfutils-libelf-devel flex openssl-devel

cd kernel
make -j32 && make install && make modules_install
dracut --regenerate-all -f && grub2-mkconfig -o /boot/grub2/grub.cfg
