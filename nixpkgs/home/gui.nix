{ config, pkgs, stdenv, lib, ... }:
let
in
{


  home.packages = with pkgs; [
    neovide
    clash
    wpsoffice
    sublime-merge
    drawio
    microsoft-edge-dev
    # wm
    (pkgs.nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
    rofi
    picom
    inter
    alacritty
    # wallpaper
    variety
    gource
  ];

  xdg.configFile."alacritty.yml" = { source = ../../conf/alacritty.yml; };

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
      exec = "qutebrowser http://clash.razord.top";
    };
  };
}
