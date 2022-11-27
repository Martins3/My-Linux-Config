{ config, pkgs, stdenv, lib, ... }:
let
  unstable = import <unstable> {
    config.allowUnfree = true;
  };

in
{

  imports = [
    ./app/gnome.nix
    /* ./gui/mime.nix */
  ];

  home.packages = with pkgs; [
    neovide
    unstable.clash
    unstable.wpsoffice
    unstable.sublime-merge
    drawio
    unstable.microsoft-edge-dev
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
      ExecStart = "${pkgs.clash.outPath}/bin/clash -d . -ext-ctl \"127.0.0.1:9090\"";
    };
  };

  xdg.desktopEntries = {
    clash = {
      name = "clash";
      exec = "microsoft-edge-dev http://clash.razord.top";
    };
  };
}
