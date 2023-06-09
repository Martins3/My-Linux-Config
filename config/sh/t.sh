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
while getopts "rh" opt; do
	case $opt in
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

mkdir -p /tmp/martins3
bpftrace_cache=/tmp/martins3/bpftrace-cache
if [[ ! -f $bpftrace_cache ]]; then
	# shellcheck disable=SC2024
	sudo bpftrace -l >"$bpftrace_cache"
fi

if [[ $# -eq 0 ]]; then
	entry=$(fzf <"$bpftrace_cache")
else
	echo "$*"
	entry=$(fzf --query="$*" <"$bpftrace_cache")
fi

scripts=""
case "$action" in
	kretprobe)
    # stdin:1:48-54: ERROR: The retval builtin can only be used with 'kretprobe' and 'uretprobe' and 'kfunc' probes
		scripts="$entry { printf(\"returned: %lx\\n\", retval); }"
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
