{ config, pkgs, stdenv, lib, ... }:
let
  unstable = import <unstable> {
    config.allowUnfree = true;
  };

in
{

  imports = [
    ./app/gnome.nix
  ];

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    neovide
    # shiori # bookmark 管理，但是没搞懂怎么使用
    unstable.wpsoffice
    # remmina # 远程桌面工具，体验一般
    # sublime-merge
    # vscode
    flameshot # 截图
    # unstable.zotero
    slack
    # drawio
    # imagemagick # 压缩照片
    # variety # wallpaper 但是 bing wallpaper 已经够好了
    kitty
    libnotify # 通知小工具
    # vmware-workstation
    # anki
    # foliate # 电子书
    wezterm # 2024-08-02 这个版本的 wez 有 bug
    # wireshark
    alacritty
    putty
    # warp-terminal
    # spacedrive # 一打开就 crash 了，目前没法用
    # zoom-us
    # spotify
    # joplin-desktop # 还有 joplin
    # gource
    # unstable.firefox
    # google-chrome
    # pot # 启动之后 segfault 了
    # libreoffice
    # thunderbird
    # feishu
    # wechat-uos
    # netease-cloud-music-gtk
    # yesplaymusic # 似乎这个也不错
    # 似乎微信又不可以用了，哈哈
    # (nur.repos.xddxdd.wechat-uos.overrideAttrs (old: {
    #   postInstall = builtins.replaceStrings
    #     ["--run"]
    #     [''--set WECHAT_DATA_DIR ${config.home.homeDirectory}/.local/share/wechat-uos/data --run'']
    #     old.postInstall;
    # }))
    # nur.repos.linyinfeng.wemeet
    microsoft-edge
    # clash-verge-rev
    # 通过 tweaks 调整开机自启动
    # gnome-tweaks # @todo 确定是这里设置的，还是只是一个 extension
    # clash-nyanpasu
    # vlc
    # podman-desktop
    # tdesktop
    # telegram
    # gparted # 需要 GTK，使用 disk 也不错
    # rofi # @todo rofi 如何使用
    # scrcpy # Android 的投屏工具
    # xmind
    # obsidian
    # rustdesk

    # distrobox # 基于容器来提供各种 distribution
    # boxbuddy # distrobox 的图形工具
  ];

  xdg.desktopEntries = {
    todo = {
      name = "Todoist";
      genericName = "ToDo";
      exec = "microsoft-edge https://todoist.com/app/today";
      icon = (pkgs.fetchurl {
        url = "https://img.icons8.com/color/512/todoist.png";
        sha256 = "0cas4frxq6rrqbllgdk9wh7a4f8blszxcynsqzcsalc3q7xilkr5";
      }).outPath;
    };

    regex = {
      name = "Regex";
      genericName = "regex";
      exec = "microsoft-edge https://regexlearn.com/zh-cn/cheatsheet";
      icon = (pkgs.fetchurl {
        url = "https://cdn-icons-png.flaticon.com/512/9804/9804194.png";
        sha256 = "1yh5lnimc0ra5lwmb7vi8yxz58knfwg27rs03xmh7v97324gw1v8";
      }).outPath;
    };

    docker = {
      name = "Docker";
      genericName = "docker";
      exec = "microsoft-edge https://dockerlabs.collabnix.com/docker/cheatsheet/";
      icon = (pkgs.fetchurl {
        url = "https://img.icons8.com/color/512/docker.png";
        sha256 = "0jbjgh9gbh75q7sli8z6zn7m0nxcawq1v4vp1v4np7k4acp7r1dn";
      }).outPath;
    };

    # @todo 这些玩意儿可以做成模板吗？
    bpftrace = {
      name = "bpftrace";
      genericName = "bpftrace";
      exec = "microsoft-edge https://github.com/bpftrace/bpftrace/blob/master/man/adoc/bpftrace.adoc";
      icon = (pkgs.fetchurl {
        url = "https://img.icons8.com/color/512/docker.png";
        sha256 = "0jbjgh9gbh75q7sli8z6zn7m0nxcawq1v4vp1v4np7k4acp7r1dn";
      }).outPath;
    };

    kernel_cmdline = {
      name = "cmdline";
      genericName = "cmdline";
      exec = "microsoft-edge https://www.kernel.org/doc/html/latest/admin-guide/kernel-parameters.html";
      icon = (pkgs.fetchurl {
        url = "https://img.icons8.com/color/512/docker.png";
        sha256 = "0jbjgh9gbh75q7sli8z6zn7m0nxcawq1v4vp1v4np7k4acp7r1dn";
      }).outPath;
    };

    crash = {
      name = "crash";
      genericName = "crash";
      exec = "microsoft-edge https://crash-utility.github.io/crash_whitepaper.html";
      icon = (pkgs.fetchurl {
        url = "https://img.icons8.com/color/512/docker.png";
        sha256 = "0jbjgh9gbh75q7sli8z6zn7m0nxcawq1v4vp1v4np7k4acp7r1dn";
      }).outPath;
    };
  };
  # https://icons8.com/icons/
  # 拷贝 url
  # nix-prefetch-url https://icons8.com/icon/17842/linux
}
