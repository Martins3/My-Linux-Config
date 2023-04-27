#!/usr/bin/env bash

set -E -e -u -o pipefail

cd ~/core/nixos-kernel
version=$(uname -r)
tarfile=linux-${version}.tar.xz

if [[ ! -f $tarfile ]]; then
	wget https://mirrors.edge.kernel.org/pub/linux/kernel/v6.x/"$tarfile"
fi

srcdir=linux-${version}
if [[ ! -d $srcdir ]]; then
	tar -xvf "$tarfile"
fi

cd "$srcdir"
zcat /proc/config.gz >.config

function exe() {
	command="$1"
	echo "$command"
	nix-shell '<nixpkgs>' -A linuxPackages_latest.kernel --command "$command"
}

# @todo
# 不知道为什么，有报错！
# 难道是因为 nixos 存在什么 patch 吗?
# exe "make ./arch/x86/kernel/kvm-intel.ko"
cat <<_EOF_
  DESCEND objtool
  DESCEND bpf/resolve_btfids
  CALL    scripts/checksyscalls.sh
make[3]: *** No rule to make target 'arch/x86/kernel/kvm-intel.o'.  Stop.
make[2]: *** [scripts/Makefile.build:504: arch/x86/kernel] Error 2
make[1]: *** [scripts/Makefile.build:504: arch/x86] Error 2
make: *** [Makefile:2021: .] Error 2
_EOF_

exe "make -32"
sudo rmmod kvm_intel kvm
sudo insmod ./arch/x86/kvm/kvm.ko
sudo insmod ./arch/x86/kvm/kvm-intel.ko

sudo modprobe kvm-intel
