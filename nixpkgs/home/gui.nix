{ config, pkgs, stdenv, lib, ... }:
let
  unstable = import <unstable> {
    config.allowUnfree = true;
  };

  wrapWine_nix = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/xieby1/nix_config/d57b5c4b1532eb5599b23c13ed063b2fa81edfa7/usr/gui/wrapWine.nix";
    hash = "sha256-4vdks0N46J/n8r3wdChXcJbBHPrbTexEN+yMi7zAbKs=";
  };
  weixin_nix = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/xieby1/nix_config/d57b5c4b1532eb5599b23c13ed063b2fa81edfa7/usr/gui/weixin.nix";
    hash = "sha256-ql6BE/IZBM31W/yqCayAdktcV2QZ/maVzwskybFZwz0=";
  };
  weixin = import weixin_nix {
    wrapWine = import wrapWine_nix { inherit pkgs; };
  };
in
{

  imports = [
    ./app/gnome.nix
  ];

  home.packages = with pkgs; [
    unstable.neovide
    unstable.clash
    unstable.wpsoffice
    unstable.sublime-merge
    unstable.flameshot
    unstable.zotero
    unstable.slack
    unstable.drawio
    unstable.variety # wallpaper
    unstable.kitty
    unstable.gource
    unstable.firefox
    unstable.microsoft-edge-dev
    # unstable.google-chrome
    unstable.thunderbird
    unstable.alacritty
    unstable.wezterm
    unstable.feishu
    tdesktop
    nur.repos.xddxdd.wechat-uos
    # nur.repos.xddxdd.qq
    # weixin # 有趣，但是不稳定
    # nur.repos.linyinfeng.wemeet
    nur.repos.linyinfeng.clash-for-windows
    nur.repos.eh5.netease-cloud-music
    # gparted # 需要 GTK，使用 disk 也不错
    rofi # @todo rofi 的使用
    scrcpy # Android 的投屏工具
    unstable.obsidian
    rustdesk
  ];

  xdg.desktopEntries = {
    todo = {
      name = "Todoist";
      genericName = "ToDo";
      exec = "microsoft-edge-dev https://todoist.com/app/today";
      icon = (pkgs.fetchurl {
        url = "https://todo.microsoft.com/favicon.ico";
        sha256 = "1742330y3fr79aw90bysgx9xcfx833n8jqx86vgbcp21iqqxn0z8";
      }).outPath;
    };
  };
}
