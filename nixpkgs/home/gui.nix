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

  home.packages = with pkgs; [
    neovide
    # shiori # bookmark 管理，但是没搞懂怎么使用
    unstable.wpsoffice
    unstable.sublime-merge
    unstable.vscode
    unstable.flameshot # 截图
    # unstable.zotero
    unstable.slack
    # unstable.drawio
    # variety # wallpaper 但是 bing wallpaper 已经够好了
    kitty
    wezterm
    wireshark
    unstable.alacritty
    # zoom-us
    # spotify
    # joplin-desktop # 还有 joplin
    # gource
    unstable.firefox
    google-chrome
    unstable.thunderbird
    # unstable.feishu
    microsoft-edge
    vlc
    # podman-desktop
    # tdesktop
    # telegram
    # unstable.clash-verge # 时不时连不上网，难道是我设置不对
    # gparted # 需要 GTK，使用 disk 也不错
    # rofi # @todo rofi 的使用
    # scrcpy # Android 的投屏工具
    # xmind
    # obsidian
    # rustdesk
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
      exec = "microsoft-edge https://github.com/iovisor/bpftrace/blob/master/docs/reference_guide.md";
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
