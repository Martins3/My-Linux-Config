{ config, pkgs, stdenv, lib, ... }:
let
  feishu = pkgs.callPackage
    (pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/xieby1/nix_config/main/usr/gui/feishu.nix";
      sha256 = "0j21j29phviw9gvf6f8fciylma82hc3k1ih38vfknxvz0cj3hvlv";
    })
    { };

  # TMP_TODO 如果想要多个文件持有这个变量，怎么操作
  /* microsoft-edge-dev = pkgs.callPackage ./programs/microsoft-edge-dev.nix {}; */
  nixpkgs_unstable = import
    (builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/ac608199012d63453ed251b1e09784cd841774e5.tar.gz";
      sha256 = "0bcy5aw85f9kbyx6gv6ck23kccs92z46mjgid3gky8ixjhj6a8vr";
    })
    { config.allowUnfree = true; };
in
{


  home.packages = with pkgs; [
    neovide
    clash
    feishu
    wpsoffice
    sublime-merge
    microsoft-edge-dev
    # wm
    (pkgs.nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
    rofi
    picom
    inter
    alacritty
    # wallpaper
    variety
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
