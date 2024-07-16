#!/usr/bin/env bash

set -E -e -u -o pipefail

# 路径参考这个:
# https://wiki.archlinux.org/title/Rime
CONFIG_DIR=~/Library/Rime # maos
if [[ $OSTYPE == "linux-gnu"* ]]; then
	# CONFIG_DIR=$HOME/.local/share/fcitx5/rime/
	CONFIG_DIR=$HOME/.config/ibus/rime
fi
mkdir -p "$CONFIG_DIR"

# 安装 plum
cd ~/core/
if [[ ! -d plum ]]; then
	git clone https://github.com/rime/plum
fi
cd plum
# 使用 plum 安装基础组件
rime_dir="$CONFIG_DIR" bash rime-install

# 从雾凇拼音 中拷贝词库过来
function update_idct_from_ice() {
	cd ~/core
	if [[ ! -d rime-ice ]]; then
		git clone --depth=1 https://github.com/iDvel/rime-ice
	fi
	cd rime-ice
	git pull
	cp -r cn_dicts "$CONFIG_DIR"
}

update_idct_from_ice

# 部署上我的配置
shopt -s extglob nullglob
cd ~/.dotfiles/rime
for i in *.@(yaml|txt); do
	ln -sf "$(pwd)/$i" "$CONFIG_DIR/$i"
done
