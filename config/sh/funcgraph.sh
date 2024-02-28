#!/usr/bin/env bash
set -E -e -u -o pipefail

mkdir -p /tmp/martins3
bpftrace_cache=/tmp/martins3/available_filter_functions
if [[ ! -s $bpftrace_cache ]]; then
	# shellcheck disable=SC2024
	sudo cat /sys/kernel/debug/tracing/available_filter_functions | tee $bpftrace_cache
fi

if [[ $# -eq 0 ]]; then
	entry=$(fzf <"$bpftrace_cache")
else
	echo "$*"
	entry=$(fzf --query="$*" <"$bpftrace_cache")
fi

set -x
sudo perf ftrace -C0 -G "${entry% \[*\]}"  -g 'smp_*'
