#!/usr/bin/env bash
set -E -e -u -o pipefail
set -x

source=~/core/linux
target=~/core/linux-build

A=/tmp/martins3/source_build_unstage.diff
B=/tmp/martins3/source_build_staged.diff
cd $source
git diff >$A
git diff --cached >$B

A1=/tmp/martins3/target_build_unstage.diff
B1=/tmp/martins3/target_build_staged.diff
cd $target
git pull
git diff >$A1
git diff --cached >$B1

function update() {
	git reset --hard
	[[ -s $A ]] && git apply $A
	[[ -s $B ]] && git apply $B
}

if diff $A $A1 &>/dev/null; then
	if diff $B $B1 &>/dev/null; then
		echo "Nothing changed, nothing to do 😹"
		cp ~/core/linux/.config ~/core/linux-build/
		exit 0
	fi
fi

update
