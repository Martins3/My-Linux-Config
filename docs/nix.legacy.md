# 记录一些曾经尝试解决，但是不用 NixOS 就立刻解决的问题

## 如何自动 login 似乎在图形界面上才可以配置

在 settings 中搜 login ，有一个 autoLogin 的选项。

https://help.gnome.org/admin/system-admin-guide/stable/login-automatic.html.en

配置之后接入如下:
```txt
🧀  cat /etc/gdm/custom.conf
[daemon]
AutomaticLogin=martins3
AutomaticLoginEnable=true
WaylandEnable=false
```

但是使用 nixos 的配置:

```txt
  services.displayMnager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "martins3";
  services.xserver.displayManager.gdm.autoLogin.delay = 1;
```
会有很多诡异的想象。

使用 fedora 后，此问题消失。

## nixos 的 kernel 有方便的方法裁剪吗？

nixos 构建过程不能利用 cacahe ，现在修改一个 patch 就要重新构建整个内核
比构建一个 rpm 然后安装还慢

此外，现在 systemd 中构建一次之后，在 zsh 中还是需要重新 make 一次

- https://nixos.wiki/wiki/Linux_kernel
- https://nixos.wiki/wiki/Kernel_Debugging_with_QEMU
- https://nixos.org/manual/nixos/stable/#sec-kernel-config

总体来说，构建
- 从哪里获取到 debuginfo ，如果可以获取，那么就可以使用 crash 来实现实时系统的分析

https://nixos.org/manual/nixos/stable/#sec-kernel-config
- 参考这个操作: https://github.com/fghibellini/nixos-kernel-module
- 然后阅读一下: https://blog.prag.dev/building-kernel-modules-on-nixos

没必要那么复杂，参考这个，中的 : Developing out-of-tree kernel modules

- https://nixos.wiki/wiki/Linux_kernel

```sh
nix-shell '<nixpkgs>' -A linuxPackages_latest.kernel.dev
make -C $(nix-build -E '(import <nixpkgs> {}).linuxPackages_latest.kernel.dev' --no-out-link)/lib/modules/*/build M=$(pwd) modules

make SYSSRC=$(nix-build -E '(import <nixpkgs> {}).linuxPackages_latest.kernel.dev' --no-out-link)/lib/modules/$(uname -r)/source
```

### 如何调试 host 内核

参考 nixpkgs/pkgs/os-specific/linux/kernel/linux-6.2.nix ，我发现其

- [ ] nixpkgs/pkgs/top-level/linux-kernels.nix 中应该会告诉是否打了 patch 以及函数的情况
  - [ ] 使用 /proc/config.gz 维持下生活吧
  - sudo insmod arch/x86/kvm/kvm-intel.ko # 似乎不行
  - 修改一个字母，所有内容全部重新编译，这不科学啊！

## 一些没用的 systemd 服务
```nix
  systemd.user.services.kernel = {
    enable = true;
    unitConfig = { };
    serviceConfig = {
      # User = "martins3";
      Type = "forking";
      # RemainAfterExit = true;
      ExecStart = "/home/martins3/.nix-profile/bin/tmux new-session -d -s kernel '/run/current-system/sw/bin/bash /home/martins3/.dotfiles/scripts/systemd/sync-kernel.sh'";
      Restart = "no";
    };
  };

  # systemctl --user list-timers --all
  systemd.user.timers.kernel = {
    enable = true;
    # timerConfig = { OnCalendar = "*-*-* 4:00:00"; };
    timerConfig = { OnCalendar = "Fri *-*-* 4:00:00"; }; #  周五早上四点运行一次
    wantedBy = [ "timers.target" ];
  };

  systemd.user.timers.drink_water = {
    enable = true;
    timerConfig = { OnCalendar="*:0/5"; };
    wantedBy = [ "timers.target" ];
  };

  systemd.user.services.drink_water = {
    enable = false;
    unitConfig = { };
    serviceConfig = {
      Type = "forking";
      ExecStart = "/run/current-system/sw/bin/bash /home/martins3/.dotfiles/scripts/systemd/drink_water.sh";
      Restart = "no";
    };
  };

  systemd.user.services.monitor = {
    enable = false;
    unitConfig = { };
    serviceConfig = {
      Type = "simple";
      ExecStart = "/run/current-system/sw/bin/bash /home/martins3/.dotfiles/scripts/systemd/monitor.sh";
      Restart = "no";
    };
    wantedBy = [ "timers.target" ];
  };
```

## 搭建下 nixos 上 hack kvm 的方法
- https://phip1611.de/blog/building-an-out-of-tree-linux-kernel-module-in-nix/

## 构建 github action

```txt
  services.github-runners = {
    testrunner = {
      enable = true;
      user = "martins3";
      name = "test-runner";
      # token file is somewhere on local machine - in my case, it's not currently managed by nix
      tokenFile = "/home/martins3/.github-runners";
      url = "https://github.com/Martins3/R9000P";
    };
  };
```

tokenFile 只是需要包含 github 指导步骤中的 token 即可

```txt
./config.sh --url https://github.com/Martins3/R9000P --token xxx
```

不需要这么复杂的机制

## 微信

```nix
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
```

## lsof 存在警告

```txt
[sudo] password for martins3:
lsof: WARNING: can't stat() fuse.gvfsd-fuse file system /run/user/1000/gvfs
      Output information may be incomplete.
lsof: WARNING: can't stat() fuse.portal file system /run/user/1000/doc
      Output information may be incomplete.
COMMAND   PID     USER   FD   TYPE DEVICE SIZE/OFF     NODE NAME
zsh     34262 martins3  cwd    DIR  259,2     4096 39060352 bus
sleep   34801 martins3  cwd    DIR  259,2     4096 39060352 bus
```
后来就没有了

## 双系统

https://nixos.wiki/wiki/Bootloader

在 13900K 上可以采用这个系统，但是笔记本上似乎有问题，而且 grub 本身有时候会出现问题。

```nix
  /* /dev/nvme1n2p3: BLOCK_SIZE="512" UUID="0470864A70864302" TYPE="ntfs" PARTUUID="8402854e-03" */
  /* /dev/nvme1n2p1: LABEL="M-gM-3M-;M-gM-;M-^_M-dM-?M-^]M-gM-^UM-^Y" BLOCK_SIZE="512" UUID="409E41739E416310" TYPE="ntfs" PARTUUID="8402854e-01" */
  /* /dev/nvme1n2p2: BLOCK_SIZE="512" UUID="02084242084234C7" TYPE="ntfs" PARTUUID="8402854e-02" */
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      # assuming /boot is the mount point of the  EFI partition in NixOS (as the installation section recommends).
      efiSysMountPoint = "/boot";
    };
    grub = {
      # https://www.reddit.com/r/NixOS/comments/wjskae/how_can_i_change_grub_theme_from_the/
      # theme = pkgs.nixos-grub2-theme;
      theme =
        pkgs.fetchFromGitHub {
          owner = "shvchk";
          repo = "fallout-grub-theme";
          rev = "80734103d0b48d724f0928e8082b6755bd3b2078";
          sha256 = "sha256-7kvLfD6Nz4cEMrmCA9yq4enyqVyqiTkVZV5y4RyUatU=";
        };
      # despite what the configuration.nix manpage seems to indicate,
      # as of release 17.09, setting device to "nodev" will still call
      # `grub-install` if efiSupport is true
      # (the devices list is not used by the EFI grub install,
      # but must be set to some value in order to pass an assert in grub.nix)
      devices = [ "nodev" ];
      efiSupport = true;

      # useOSProber = true; # 没有说的那么不堪，还是很好用的

      enable = true;
      # set $FS_UUID to the UUID of the EFI partition
      # /dev/nvme1n1p1: BLOCK_SIZE="512" UUID="3A22AF3A22AEF9D1" TYPE="ntfs" PARTLABEL="Basic data partition" PARTUUID="1b23d1fb-c1ad-4b8b-83e1-79005771a027"
      extraEntries = ''
        menuentry "Windows" {
          insmod part_gpt
          insmod fat
          search --fs-uuid --set=root 4957-45A0
          chainloader /EFI/Microsoft/Boot/bootmgfw.efi
        }
      '';
      version = 2;
    };
  };

```


## 桌面环境

- https://wiki.hyprland.org/Nix/
- https://github.com/yaocccc/dwm : 看上去还不错，还有 bilibili 的介绍

启用 hyprland 的方法:

```diff
commit 6746b06b79275b160a433567b47d5e6c49445e77
Author: Martins3 <hubachelar@gmail.com>
Date:   Sun Jun 25 22:23:53 2023 +0800

    cool

diff --git a/nixpkgs/home/gui.nix b/nixpkgs/home/gui.nix
index 8f0d909..fac00dc 100644
--- a/nixpkgs/home/gui.nix
+++ b/nixpkgs/home/gui.nix
@@ -19,7 +19,7 @@ in
 {

   imports = [
-    ./app/gnome.nix
+    # ./app/gnome.nix
   ];

   home.packages = with pkgs; [
diff --git a/nixpkgs/sys/gui.nix b/nixpkgs/sys/gui.nix
index 61f4f3e..a525fb5 100644
--- a/nixpkgs/sys/gui.nix
+++ b/nixpkgs/sys/gui.nix
@@ -1,17 +1,17 @@
 { config, pkgs, ... }:

 {
-  services.xserver = {
-    enable = true;
-    xkbOptions = "caps:swapescape";
-    # 暂时可以使用这个维持生活吧
-    # gsettings set org.gnome.desktop.input-sources xkb-options "['caps:swapescape']"
-    # https://nixos.org/manual/nixos/stable/index.html#sec-gnome-gsettings-overrides
-  };
+  # services.xserver = {
+  #   enable = true;
+  #   xkbOptions = "caps:swapescape";
+  #   # 暂时可以使用这个维持生活吧
+  #   # gsettings set org.gnome.desktop.input-sources xkb-options "['caps:swapescape']"
+  #   # https://nixos.org/manual/nixos/stable/index.html#sec-gnome-gsettings-overrides
+  # };

-  services.xserver.displayManager.gdm.enable = true;
-  services.xserver.displayManager.gdm.wayland = false;
-  services.xserver.desktopManager.gnome.enable = true;
+  # services.xserver.displayManager.gdm.enable = true;
+  # services.xserver.displayManager.gdm.wayland = false;
+  # services.xserver.desktopManager.gnome.enable = true;

   # see xieby1
   fonts.fonts = (
diff --git a/nixpkgs/system.nix b/nixpkgs/system.nix
index 8490c95..c1c018b 100644
--- a/nixpkgs/system.nix
+++ b/nixpkgs/system.nix
@@ -20,6 +20,12 @@ in
     "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
     "https://cache.nixos.org/"
   ];
+  programs.hyprland.enable = true;
+ services.xserver.desktopManager = {
+    gnome.enable = false;
+    plasma5.enable = false;
+    xterm.enable = false;
+  };

   time.timeZone = "Asia/Shanghai";
   time.hardwareClockInLocalTime = true;
```

还是感觉收益不大，而且启动之后 edge 无法使用。再度放弃。

## nixos 支持 kernel dump 的功能
否则找不到 /proc/vmcore

参考:
- https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/misc/crashdump.nix
- https://search.nixos.org/options?channel=22.05&show=boot.crashDump.enable&from=0&size=50&sort=relevance&type=packages&query=boot.crashDump.enable

使用这个方法可以检查到 CONFIG 的确修改过:
https://superuser.com/questions/287371/obtain-kernel-config-from-currently-running-linux-system

```txt
➜  .dotfiles git:(backup) zgrep CONFIG_CRASH /proc/config.gz
CONFIG_CRASH_DUMP=y
CONFIG_CRASH_CORE=y
```

crashdump.nix 中，postCommand 是给

- [ ] 无法理解，在 nixos 的启动中，我检查到了这个
```txt
[    2.473781] stage-2-init: running activation script...
[    2.843469] stage-2-init: setting up /etc...
[    3.453159] stage-2-init: loading crashdump kernel...
```

https://gist.github.com/Mic92/4fdf9a55131a7452f97003f445294f97


## 痛苦的回忆

垃圾 nixos ，让 initrd 的打包始终存在问题:
```sh
function nixos_crash_workaround() {
	dump_guest_path=$1
	vmlinux=$2
	# nixos 中构建不出来 crash ，用 docker 来 workaround
	local image_dir
	local vmlinux_dir
	image_dir=$(dirname "$dump_guest_path")
	image=$(basename "$dump_guest_path")
	vmlinux_dir=$(dirname "$vmlinux")
	vmlinux=$(basename "$vmlinux")
	echo "$image_dir"
	echo "$vmlinux_dir"
	set -x
	docker run -it --rm --workdir /root \
		-v "$image_dir":/root/image \
		-v "$vmlinux_dir":/root/vmlinux \
		fedora:initrd \
		crash "/root/image/$image" "/root/vmlinux/$vmlinux"
}
```
