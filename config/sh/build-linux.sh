#!/usr/bin/env bash
set -E -e -u -o pipefail

use_llvm="LLVM=1"

target=~/core/linux-build

while getopts "baxgu" opt; do
	case $opt in
		b) target=~/core/linux-build ;;
		a) target=~/core/linux-aarch64 ;;
		g) target=~/core/linux-gcov ;;
		u) target=~/core/linux-uml ;;
		x)
			echo "build x86 on aarch64 host"
			exit 1
			;;
		*)
			echo "-b linux-build"
			echo "-a linux-aarch64"
			echo "-a linux-gcov"
			;;
	esac
done

if [[ -z $target ]]; then
	echo "No target to build 😘"
	exit 0
fi

source=~/core/linux

target_dir=$(basename $target)

A=/tmp/martins3/source_build_unstage.diff
B=/tmp/martins3/source_build_staged.diff
A1=/tmp/martins3/"$target_dir"/target_build_unstage.diff
B1=/tmp/martins3/"$target_dir"/target_build_staged.diff

mkdir -p /tmp/martins3/"$target_dir"

function get_diff() {
	if ! cd $target; then
		git clone $source $target
	fi
	cd $source
	git diff >$A
	git diff --cached >$B

	cd $target
	git pull
	git diff >"$A1"
	git diff --cached >"$B1"

	if diff $A "$A1" &>/dev/null; then
		if diff $B "$B1" &>/dev/null; then
			return 1
		fi
	fi
}

function update() {
	git reset --hard
	if [[ -s $A ]]; then
		git apply $A || true
	fi

	if [[ -s $B ]]; then
		git apply $B || true
	fi
}

if ! get_diff; then
	echo "Nothing changed, nothing to do 😹"
fi
update

cd $target

if [[ ! -e default.nix ]]; then
	ln -sf /home/martins3/.dotfiles/scripts/nix/env/linux.nix default.nix
	echo "use nix" >>.envrc && direnv allow
fi

cores=$(getconf _NPROCESSORS_ONLN)
cores=3
case $target_dir in
	linux-build)
		cp $source/.config .
		chrt -i 0 make LLVM=1 -j"$cores"
		;;
	linux-aarch64)
		cp ~/.dotfiles/scripts/systemd/martins3.config kernel/configs/martins3.config
		make ARCH=arm64 LLVM=1 defconfig kvm_guest.config martins3.config -j"$cores"
		KBUILD_BUILD_TIMESTAMP='' make LLVM=1 CC="ccache clang" ARCH=arm64 -j"$cores"
		# 在 nixos 上，你需要一点小小的技巧才可以较差编译
		# 参考 config/sh/test.c
		./scripts/clang-tools/gen_compile_commands.py
		sed -i 's/-mabi=lp64//g' compile_commands.json
		;;
	linux-gcov)
		cp ~/.dotfiles/scripts/systemd/martins3.config kernel/configs/martins3.config
		cp ~/.dotfiles/scripts/systemd/kconv.config kernel/configs/kconv.config
		make $use_llvm defconfig kvm_guest.config martins3.config kconv.config -j"$cores"
		nice -n 19 make $use_llvm
		;;
	linux-uml)
		# 不知道为什么，无法使用 llvm
		use_llvm=""
		make "$use_llvm" defconfig ARCH=um
		# make $use_llvm menuconfig ARCH=um
		make "$use_llvm" ARCH=um -j"$cores"
		# make $use_llvm defconfig kvm_guest.config martins3.config kconv.config -j"$cores"
		exit 1
		;;
esac
