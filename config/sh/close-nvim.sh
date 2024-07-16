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

sleep 2

if pgrep nvim; then
	echo "some nvim process can't shutdown automatically"
  exit 1
fi

# 不容易，到底如何将所有的命令发送给所有的 window 的所有的 pane
#
# for _pane in $(tmux list-panes -a -F '#W#P'); do
#     tmux send-keys -t "${_pane}" "exit"
#     tmux send-keys -t "${_pane}" Enter
# done
