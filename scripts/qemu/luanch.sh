#!/usr/bin/env bash

set -E -e -u -o pipefail

function martins3_prepare_qemu() {
  # @todo 这种检测方式有问题
  if pgrep qemu-system-x86; then
    gum confirm "there's qemu process, maybe kill it firstly"
  fi
}

function debug_kernel() {
  martins3_prepare_qemu
  echo "good"
  zellij run --close-on-exit -- /home/martins3/core/vn/docs/qemu/sh/alpine.sh -s
  /home/martins3/core/vn/docs/qemu/sh/alpine.sh -k
  gum confirm "Kill the machine?" && pkill qemu-system-x86
}

function login() {
  martins3_prepare_qemu
  zellij run --close-on-exit -- /home/martins3/core/vn/docs/qemu/sh/alpine.sh -r
  for i in x y; do
    gum spin --spinner dot --title "waiting for the vm..." -- sleep 3
    ssh -p5556 root@localhost
    if [[ $? != 255 ]]; then
      gum confirm "Kill the vm?" && pkill qemu-system-x86
    fi
    echo "try to connect to vm"
  done
}

while getopts "d" opt; do
  case $opt in
  d)
    echo "---"
    debug_kernel
    exit 0
    ;;
  *)
    login
    exit 0
    ;;
  esac
done
