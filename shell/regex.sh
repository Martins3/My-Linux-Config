#!/usr/bin/env bash

set -E -e -u -o pipefail
# shopt -s inherit_errexit
# PROGNAME=$(basename "$0")
# PROGDIR=$(readlink -m "$(dirname "$0")")
for i in "$@"; do
	echo "$i"
done
cd "$(dirname "$0")"

testfile=./test.txt

function slash() {
	printf "%030d\n" "0"
}

function egrep_vs_grep() {
	# \1 来捕获第一个，也就是 () 的第一次匹配的内容
	grep -e '^\(.*\)\1$' $testfile
	# 如果使用 -E 无需
	grep -E '^(.*)\1\(\)$' $testfile
}

function capture() {
	grep -E '(ab){2}' $testfile
	# FIXME 非捕获组 ?
	# 这个运行会出错
	grep -E '(?:ab){2}' $testfile
}

function learn_sed() {
	sed -E 's/[ch]at/ball/g' $testfile
	slash
	sed -E 's/(emacs)/\1 is bad/g' $testfile

	# 增加是在下一行的
	slash
	lines="abc\n"
	lines+="cde"
	sed -E "/(emacs)/a $lines" $testfile

  # 增加整个文件
  sed "/cdef/r nu.md" $testfile
}

function learn_rg() {
	rg "[0-9]" $testfile
	rg "\d" $testfile
	grep -E "[0-9]" $testfile
	grep -E "\d" $testfile
	grep -P "\d" $testfile
}

function learn_find() {
	# find 使用的是 glob
	find "*regex.sh"
}

egrep_vs_grep
