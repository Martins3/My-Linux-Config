#!/usr/bin/env bash

set -E -e -u -o pipefail

RIME_FRONTEND=${RIME_FRONTEND:-fcitx5}

function setup_config_dir() {
	# 路径参考这个:
	# https://wiki.archlinux.org/title/Rime
	CONFIG_DIR=~/Library/Rime # macos
	if [[ $OSTYPE == "linux-gnu"* ]]; then
		case "$RIME_FRONTEND" in
			fcitx5)
				CONFIG_DIR=$HOME/.local/share/fcitx5/rime/
				PLUM_FRONTEND=fcitx5-rime
				;;
			ibus)
				CONFIG_DIR=$HOME/.config/ibus/rime
				PLUM_FRONTEND=ibus-rime
				;;
			*)
				echo "unsupported RIME_FRONTEND: $RIME_FRONTEND" >&2
				exit 1
				;;
		esac
	fi
	mkdir -p "$CONFIG_DIR"
}

function install_rime_ice() {
	# 安装 plum
	cd ~/data/
	if [[ ! -d plum ]]; then
		git clone https://github.com/rime/plum
	fi
	cd plum
	# 使用 plum 安装基础组件
	rime_dir="$CONFIG_DIR" bash rime-install

	rime_frontend="$PLUM_FRONTEND" rime_dir="$CONFIG_DIR" bash rime-install iDvel/rime-ice:others/recipes/full
	rime_frontend="$PLUM_FRONTEND" rime_dir="$CONFIG_DIR" bash rime-install iDvel/rime-ice:others/recipes/config:schema=flypy
}

function add_extra_config() {

	# 部署上我的配置，目前看，其实大多数都是没必要的，似乎 rime-ice 的配置
  # 比我都是要好的，添加词库只有需要做这个操作
  #
  #  1. 先把自定义词库放进当前 Rime 配置目录。
  #     在 Linux + fcitx5 下，你的配置目录是 ~/.local/share/fcitx5/rime/。最简单
  #     是做软链接：
  #
  #  ln -sf ~/.dotfiles/rime/luna_pinyin.martins3.dict.yaml ~/.local/share/fcitx5/rime/
  #
  #
  #  2. 修改 ~/.local/share/fcitx5/rime/rime_ice.dict.yaml
  #     在 import_tables: 下面加一行：
  #    - luna_pinyin.martins3
  #
	cd ~/.dotfiles/rime
	config=(
		# default.custom.yaml
		# double_pinyin_flypy.custom.yaml
		# luna_pinyin.martins3.dict.yaml
		# martins3_ice.dict.yaml
		# melt_eng.custom.yaml
		# radical_pinyin.custom.yaml
		# rime_ice.custom.yaml
	)
	for i in "${config[@]}"; do
		ln -sf "$(pwd)/$i" "$CONFIG_DIR/$i"
	done
}

setup_config_dir
install_rime_ice
add_extra_config
# 最后，gnome 是需要这个机制的:
# https://extensions.gnome.org/extension/261/kimpanel/

