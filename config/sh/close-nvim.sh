#!/usr/bin/env bash
# 自动关闭所有的 vim
set -E -e -u -o pipefail
nvim_pipe_dir=/tmp/martins3/nvim
if [[ ! -d $nvim_pipe_dir ]]; then
	exit 0
fi
for i in "$nvim_pipe_dir"/*; do
	nvim --server "$i" --remote-send '<C-\><C-N>:wqa<CR>'
done

sleep 1

if pgrep nvim; then
	echo "some nvim process can't shutdown automatically"
fi
