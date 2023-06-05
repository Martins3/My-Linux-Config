#!/usr/bin/env bash

set -E -e -u -o pipefail

cd "$(dirname "$0")"

function finish {
	if [[ $? -ne 0 ]]; then
		echo "check what's happening"
		echo "v $0"
	fi
}

trap finish EXIT

action="trace"
while getopts "krh" opt; do
	case $opt in
		k)
			action="kprobe"
			;;
		r)
			action="kretprobe"
			;;
		h)
			echo "usage : t funcname"
			exit 0
			;;
		*)
			exit 1
			;;
	esac
done
shift $((OPTIND - 1))

if [[ $# -eq 0 ]]; then
	mkdir -p /tmp/martins3
	bpftrace_cache=/tmp/martins3/bpftrace-cache
	# shellcheck disable=SC2024
	if [[ ! -f $bpftrace_cache ]]; then
		sudo bpftrace -l >"$bpftrace_cache"
	fi
	entry=$(fzf <"$bpftrace_cache")
fi

scripts=""
case "$action" in
	kprobe)
		scripts="kprobe:${1} { @[kstack] = count(); }"
		;;
	kretprobe)
		scripts="kretprobe:${1} { printf(\"returned: %lx\\n\", retval); }"
		;;
	trace)
		scripts="$entry { @[kstack] = count(); }"
		;;
	*)
		exit 12
		;;
esac
echo "sudo bpftrace -e $scripts"
sudo bpftrace -e "$scripts"
