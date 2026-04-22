#!/usr/bin/env bash
set -E -e -u -o pipefail

FONT_DIR="$HOME/.local/share/fonts/lxgw-wenkai"
mkdir -p "$FONT_DIR"

BASE_URL="https://github.com/lxgw/LxgwWenKai/releases/download/v1.522"

install_font() {
  local file="$1"
  local url="$BASE_URL/$file"
  local dest="$FONT_DIR/$file"

  if [[ -f "$dest" ]]; then
    echo "Font already exists: $file"
    return 0
  fi

  echo "Downloading $file ..."
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL -o "$dest" "$url"
  elif command -v wget >/dev/null 2>&1; then
    wget -q -O "$dest" "$url"
  else
    echo "Error: curl or wget is required to download fonts." >&2
    return 1
  fi
  echo "Downloaded $file"
}

install_font "LXGWWenKai-Regular.ttf"
install_font "LXGWWenKaiMono-Regular.ttf"
install_font "LXGWWenKai-Medium.ttf"
install_font "LXGWWenKaiMono-Medium.ttf"

if command -v fc-cache >/dev/null 2>&1; then
  echo "Updating font cache..."
  fc-cache -fv "$FONT_DIR"
fi

echo "LXGW WenKai fonts installed to $FONT_DIR"
