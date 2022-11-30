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
    unstable.netease-cloud-music-gtk
    unstable.drawio
    unstable.variety # wallpaper
    unstable.kitty
    unstable.gource
    unstable.firefox
    unstable.microsoft-edge-dev
    unstable.google-chrome
    unstable.thunderbird
    /* unstable.openvpn */
    weixin
    nur.repos.linyinfeng.wemeet
    (pkgs.nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
    /* gparted # 需要 GTK，使用 disk 也不错 */
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

    todo = {
      name = "Microsoft To Do";
      genericName = "ToDo";
      exec = "microsoft-edge-dev https://to-do.live.com/";
      icon = (pkgs.fetchurl {
        url = "https://todo.microsoft.com/favicon.ico";
        sha256 = "1742330y3fr79aw90bysgx9xcfx833n8jqx86vgbcp21iqqxn0z8";
      }).outPath;
    };

    webweixin = {
      name = "网页微信";
      genericName = "wechat";
      exec = "microsoft-edge-dev  https://wx.qq.com/";
      icon = (pkgs.fetchurl {
        url = "https://cdn.cdnlogo.com/logos/w/79/wechat.svg";
        sha256 = "1xk1dsia6favc3p1rnmcncasjqb1ji4vkmlajgbks0i3xf60lskw";
      }).outPath;
    };
  };
}
