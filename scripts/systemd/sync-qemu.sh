#!/usr/bin/env bash
export PATH="$PATH:/run/wrappers/bin:/home/martins3/.nix-profile/bin"
export PATH="$PATH:/run/current-system/sw/bin/"
set -ex

function finish {
	if [[ $? == 0 ]]; then
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
	ln -sf /home/martins3/.dotfiles/scripts/nix/env/qemu.nix default.nix
fi

# https://stackoverflow.com/questions/6245570/how-do-i-get-the-current-branch-name-in-git
branch=$(git rev-parse --abbrev-ref HEAD)
if [[ $branch != master ]]; then
	echo "checkout to master"
fi

git restore --staged .gitignore
git checkout -- .gitignore

git pull

cat <<_EOF >>.gitignore
.ccls-cache
.direnv
.vim-bookmarks
compile_commands.json
default.nix
.envrc
_EOF

cores=$(getconf _NPROCESSORS_ONLN)
threads=$((cores - 1))

# --disable-tcg
# --enable-trace-backends=nop

mkdir -p /home/martins3/core/qemu/instsall
QEMU_options="  --prefix=/home/martins3/core/qemu/instsall --target-list=x86_64-softmmu --disable-werror --enable-gtk --enable-libusb"
QEMU_options+=" --enable-virglrenderer --enable-opengl --enable-numa --enable-virtfs --enable-libiscsi"
QEMU_options+=" --cc=clang  "
QEMU_options+=" --enable-virtfs"
QEMU_options+=" --extra-cflags=\"-Wno-error=unused-command-line-argument\"" # @todo 怎么解决下这个警告

nix-shell --command "mkdir -p build && cd build && ../configure ${QEMU_options}  && cp compile_commands.json .. "
nix-shell --command "cd build && chrt -i 0 make CC='ccache gcc' -j$threads"
# nvim -c ":e softmmu/vl.c" -c "lua vim.loop.new_timer():start(1000 * 60 * 30, 0, vim.schedule_wrap(function() vim.api.nvim_command(\"exit\") end))"
