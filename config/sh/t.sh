#!/usr/bin/env bash

set -E -e -u -o pipefail

check_return=false
while getopts "r" opt; do
	case $opt in
		r)
			check_return=true
			;;
		*)
			exit 1
			;;
	esac
done
shift $((OPTIND - 1))

for i in "$@"; do
	echo "$i"
done
cd "$(dirname "$0")"
if [[ $# -eq 0 ]]; then
	echo "usage : t funcname"
	exit 1
fi

set -x

if [[ $check_return == true ]]; then
	sudo bpftrace -e "kretprobe:${1} { printf(\"returned: %lx\\n\", retval); }"
else
	sudo bpftrace -e "kprobe:${1} {  @[kstack] = count(); }"
fi
