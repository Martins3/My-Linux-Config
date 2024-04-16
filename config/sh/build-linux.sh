#!/usr/bin/env bash
set -E -e -u -o pipefail
set -x

use_llvm="LLVM=1"

target=""
while getopts "baxg" opt; do
	case $opt in
		b) target=~/core/linux-build ;;
		a) target=~/core/linux-aarch64 ;;
		g) target=~/core/linux-gcov ;;
		x)
			echo "build x86 on aarch64 host"
			exit 1
			;;
		*)
			exit 1
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
cores=$(getconf _NPROCESSORS_ONLN)
case $target_dir in
	linux-build)
		cp $source/.config $target
		;;
	linux-aarch64)
		cp ~/.dotfiles/scripts/systemd/martins3.config kernel/configs/martins3.config
		make ARCH=arm64 LLVM=1 defconfig kvm_guest.config martins3.config -j"$cores"
		KBUILD_BUILD_TIMESTAMP='' make LLVM=1 CC="ccache clang" ARCH=arm64 -j"$cores"
		./scripts/clang-tools/gen_compile_commands.py
		sed -i 's/-mabi=lp64//g' compile_commands.json
		;;
	linux-gcov)
		cp ~/.dotfiles/scripts/systemd/kconv.config kernel/configs/kconv.config
		make $use_llvm defconfig kvm_guest.config martins3.config kconv.config -j"$cores"
		nice -n 19 make $use_llvm
		;;
esac
