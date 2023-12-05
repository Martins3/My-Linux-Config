#!/usr/bin/env bash
set -E -e -u -o pipefail

mkdir -p /tmp/martins3
bpftrace_cache=/tmp/martins3/available_filter_functions
if [[ ! -s $bpftrace_cache ]]; then
	# shellcheck disable=SC2024
	sudo cat /sys/kernel/debug/tracing/available_filter_functions | tee $bpftrace_cache
fi

trap finish EXIT

function finish {
	echo nop | sudo tee /sys/kernel/debug/tracing/current_tracer
	echo | sudo tee /sys/kernel/debug/tracing/set_event
	echo | sudo tee /sys/kernel/debug/tracing/trace
}

finish

if [[ $# -eq 0 ]]; then
	entry=$(fzf <"$bpftrace_cache")
else
	echo "$*"
	entry=$(fzf --query="$*" <"$bpftrace_cache")
fi

echo  function_graph | sudo tee /sys/kernel/debug/tracing/current_tracer
echo "${entry%\[*\]}" | sudo tee /sys/kernel/debug/tracing/set_graph_function
echo | sudo tee /sys/kernel/debug/tracing/set_ftrace_filter # 有点奇葩，为什么不清空会影响输出的内容
sudo cat /sys/kernel/debug/tracing/trace_pipe
