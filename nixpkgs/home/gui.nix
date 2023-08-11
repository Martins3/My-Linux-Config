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
    neovide
    # shiori # bookmark 管理，但是没搞懂怎么使用
    # unstable.clash
    unstable.wpsoffice
    unstable.sublime-merge
    unstable.vscode
    unstable.flameshot # 截图
    unstable.zotero
    unstable.slack
    unstable.drawio
    # variety # wallpaper 但是 bing wallpaper 已经够好了
    kitty
    wezterm
    unstable.alacritty
    zoom-us
    spotify
    # joplin-desktop # 还有 joplin
    # gource
    unstable.firefox
    unstable.microsoft-edge-dev
    # unstable.google-chrome
    unstable.thunderbird
    unstable.feishu
    podman-desktop
    # tdesktop # telegram
    # unstable.flutter # 版本不足以支持 localsend @todo 等到支持的时候再去分析吧
    # nur.repos.xddxdd.wechat-uos # 别整这些虚头巴脑了，还是虚拟机吧，解决一切问题。
    # nur.repos.xddxdd.qq
    # weixin # 有趣，但是不稳定
    # nur.repos.linyinfeng.wemeet
    nur.repos.linyinfeng.clash-for-windows
    # nur.repos.eh5.netease-cloud-music
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
      exec = "microsoft-edge-beta https://todoist.com/app/today";
      icon = (pkgs.fetchurl {
        url = "https://img.icons8.com/color/512/todoist.png";
        sha256 = "0cas4frxq6rrqbllgdk9wh7a4f8blszxcynsqzcsalc3q7xilkr5";
      }).outPath;
    };

    regex = {
      name = "Regex";
      genericName = "regex";
      exec = "microsoft-edge-beta https://regexlearn.com/zh-cn/cheatsheet";
      icon = (pkgs.fetchurl {
        url = "https://cdn-icons-png.flaticon.com/512/9804/9804194.png";
        sha256 = "1yh5lnimc0ra5lwmb7vi8yxz58knfwg27rs03xmh7v97324gw1v8";
      }).outPath;
    };

    docker = {
      name = "Docker";
      genericName = "docker";
      exec = "microsoft-edge-beta https://dockerlabs.collabnix.com/docker/cheatsheet/";
      icon = (pkgs.fetchurl {
        url = "https://img.icons8.com/color/512/docker.png";
        sha256 = "0jbjgh9gbh75q7sli8z6zn7m0nxcawq1v4vp1v4np7k4acp7r1dn";
      }).outPath;
    };

    # @todo 这些玩意儿可以做成模板吗？
    bpftrace = {
      name = "bpftrace";
      genericName = "bpftrace";
      exec = "microsoft-edge-beta https://github.com/iovisor/bpftrace/blob/master/docs/reference_guide.md";
      icon = (pkgs.fetchurl {
        url = "https://img.icons8.com/color/512/docker.png";
        sha256 = "0jbjgh9gbh75q7sli8z6zn7m0nxcawq1v4vp1v4np7k4acp7r1dn";
      }).outPath;
    };

    kernel_cmdline = {
      name = "cmdline";
      genericName = "cmdlien";
      exec = "microsoft-edge-beta https://www.kernel.org/doc/html/latest/admin-guide/kernel-parameters.html";
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
