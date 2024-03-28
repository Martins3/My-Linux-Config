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
# 可以指定 CPU
sudo perf ftrace -G "${entry% \[*\]}"  -g 'smp_*' -g irq_enter_rcu -g __sysvec_irq_work -g irq_exit_rcu
