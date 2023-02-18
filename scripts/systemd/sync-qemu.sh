#!/usr/bin/env bash
set -ex
export PATH="$PATH:/run/wrappers/bin:/home/martins3/.nix-profile/bin"
export PATH="$PATH:/run/current-system/sw/bin/"

function finish {
  if [[ $? == 0 ]]; then
    sleep 600
    exit 0
  fi
  sleep infinity
}

trap finish EXIT

if cd /home/martins3/core/qemu; then
  echo "qemu already setup"
else
  mkdir -p /home/martins3/core/
  cd /home/martins3/core
  git clone https://github.com/qemu/qemu
  cd qemu
fi

# https://stackoverflow.com/questions/6245570/how-do-i-get-the-current-branch-name-in-git
branch=$(git rev-parse --abbrev-ref HEAD)
if [[ $branch != master ]]; then
  echo "checkout to master"
fi

git pull
# --disable-tcg
# --enable-trace-backends=nop
# @todo 用上 virtfs 的

mkdir -p /home/martins3/core/qemu/instsall
QEMU_options="--prefix=/home/martins3/core/qemu/instsall --target-list=x86_64-softmmu --disable-werror --enable-gtk --enable-virtfs --enable-libusb --enable-virglrenderer --enable-opengl"

nix-shell --command "mkdir -p build && cd build && ../configure ${QEMU_options}  && cp compile_commands.json .. && make -j"
nvim "+let g:auto_session_enabled = v:false" -c ":e softmmu/vl.c" -c "lua vim.loop.new_timer():start(1000 * 60 * 30, 0, vim.schedule_wrap(function() vim.api.nvim_command(\"exit\") end))"
