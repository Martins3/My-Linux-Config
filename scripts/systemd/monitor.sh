#!/usr/bin/env bash
set -E -e -u -o pipefail

set -x
export PATH="$PATH:/home/martins3/.cargo/bin"
export PATH="$PATH:/home/martins3/.npm-packages/bin"
export PATH="$PATH:/home/martins3/.cargo/bin"
export PATH="$PATH:/home/martins3/.npm-packages/bin"
export PATH="$PATH:/run/wrappers/bin:/home/martins3/.nix-profile/bin"
export PATH="$PATH:/etc/profiles/per-user/martins3/bin"
export PATH="$PATH:/nix/var/nix/profiles/default/bin"
export PATH="$PATH:/run/current-system/sw/bin"
export PATH="$PATH:/home/martins3/.zsh/plugins/zsh-autosuggestions"

function send() {
  metric=$1
  value=$2
  curl -d "martins3,tag=13900K $metric=$value" -X POST 'http://127.0.0.1:8428/write'
}

function cache() {
  value=$(grep "^Cached:" /proc/meminfo | awk -F ' ' '{print $2}')
  send Cache "$value"
}

while true; do
  cache
  sleep 10
done
