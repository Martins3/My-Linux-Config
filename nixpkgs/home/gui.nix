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
    weixin
    neovide
    unstable.clash
    unstable.wpsoffice
    unstable.sublime-merge
    unstable.firefox
    drawio
    unstable.microsoft-edge-dev
    nur.repos.linyinfeng.wemeet
    # wm
    (pkgs.nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
    rofi
    picom
    inter
    # wallpaper
    variety
    gource
    kitty
    unstable.slack
    unstable.netease-cloud-music-gtk
  ];

  systemd.user.services.clash = {
    Unit = {
      Description = "Auto start clash";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.clash.outPath}/bin/clash";
    };
  };

  xdg.desktopEntries = {
    clash = {
      name = "clash";
      exec = "microsoft-edge-dev http://clash.razord.top";
    };
  };
}
