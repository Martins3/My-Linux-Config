# add this file to /etc/nixos/configuration.nix: imports
{ boot_efi ? 1, disable_gui ? 0}:{ config, pkgs, lib, ... }:

let

  unstable = import <nixos-unstable> { };
in
{
  imports = [
    ./sys/cli.nix
    ./sys/net.nix
    ./sys/kernel-options.nix
    ./sys/kernel-config.nix
    # ./sys/kernel-419.nix
  ] ++ (
  if disable_gui == 0 && builtins.currentSystem == "x86_64-linux" then [
      ./sys/gui.nix
    ] else [ ]
  ) ++ (
  if boot_efi == 1 then [
      ./sys/boot.nix
    ] else [ ]
  );

  services.openssh.enable = true;

  nix.settings.substituters = [
    "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
    "https://cache.nixos.org/"
  ];

  time.timeZone = "Asia/Shanghai";
  time.hardwareClockInLocalTime = true;

  # nvidia GPU card configuration, for details,
  # 注意: 如果你和我一样，用的是老显卡，将  open = true; 注释掉
  # see https://nixos.wiki/wiki/Nvidia

  programs.zsh.enable = true;


  nixpkgs.overlays = [
    (let
     pinnedPkgs = import(pkgs.fetchFromGitHub {
       owner = "NixOS";
       repo = "nixpkgs";
       rev = "b6bbc53029a31f788ffed9ea2d459f0bb0f0fbfc";
       sha256 = "sha256-JVFoTY3rs1uDHbh0llRb1BcTNx26fGSLSiPmjojT+KY=";
       }) {};
     in
     final: prev: {
     docker = pinnedPkgs.docker;
     })
  ];

  virtualisation.docker.enable = true;
  virtualisation.docker.daemon.settings = {
    bip = "10.11.0.1/16";
  };
  virtualisation.podman.enable = true;
  virtualisation.vswitch.enable = true;
  virtualisation.vswitch.package = pkgs.openvswitch-lts;

  virtualisation.libvirtd.enable = true;

  zramSwap.enable = true;

  # networking.proxy.default = "http://127.0.0.1:8889";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    zsh
    unstable.tailscale
    cifs-utils
    parted
    k3s
  ];

  # https://nixos.wiki/wiki/Fwupd
  # 似乎没啥用，而且还是存在 bug 的
  services.fwupd.enable = false;


  users.mutableUsers = false;
  users.users.martins3 = {
    isNormalUser = true;
    shell = pkgs.zsh;
    # shell = pkgs.nushell;
    home = "/home/martins3";
    extraGroups = [ "wheel" "docker" "libvirtd" ];
  };


  services.k3s.enable = false;
  services.k3s.role = "server";
  services.k3s.extraFlags = toString [
    # "--kubelet-arg=v=4" # Optionally add additional args to k3s
  ];


  # GPU passthrough with vfio need memlock
  # https://www.reddit.com/r/VFIO/comments/aiwrzr/12_qemu_hardware_error_vfio_dma_mapping_failed/
  security.pam.loginLimits = [
    { domain = "*"; type = "-"; item = "memlock"; value = "infinity"; }
  ];

  # 默认是 cgroup v2
  # systemd.enableUnifiedCgroupHierarchy = false; # cgroup v1

  # 组装机器之后，这个需求并不强了
  # services.syncthing = {
  #   enable = true;
  #   systemService = true;
  #   # relay.enable = true;
  #   user = "martins3";
  #   dataDir = "/home/martins3";
  #   overrideDevices = false;
  #   overrideFolders = false;
  #   guiAddress = "0.0.0.0:8384";
  # };

  documentation.enable = true;

  # earlyoom 检查方法 sudo journalctl -u earlyoom | grep sending
  # @todo services 和 systemd 的差别是什么?
  systemd.oomd = {
    enable = true;
  };

  systemd.user.services.clash = {
    enable = true;
    unitConfig = { };
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.clash-meta.outPath}/bin/clash-meta";
      Restart = "no";
    };
    wantedBy = [ "default.target" ];
  };

  systemd.user.services.pueued = {
    enable = true;
    unitConfig = { };
    serviceConfig = {
      ExecStart = "${pkgs.pueue.outPath}/bin/pueued -vv";
      Restart = "no";
    };
    wantedBy = [ "default.target" ];
  };

  systemd.user.services.kernel_doc = {
    enable = true;
    description = "export kernel doc at 127.0.0.1:3434";
    serviceConfig = {
      WorkingDirectory = "/home/martins3/core/linux/Documentation/output";
      Type = "simple";
      ExecStart = "/home/martins3/.nix-profile/bin/python -m http.server 3434";
      Restart = "no";
    };
    wantedBy = [ "timers.target" ];
  };

  systemd.services.hugepage = {
    enable = true;
    description = "make user process access hugepage";
    serviceConfig = {
      Type = "simple";
      ExecStart = "/run/current-system/sw/bin/chmod o+w /dev/hugepages/";
      Restart = "no";
    };
    wantedBy = [ "multi-user.target" ];
  };

  # @todo 使用下吧
  systemd.services.iscsid = {
    enable = true;
  };
  nix.settings.experimental-features = "nix-command flakes";
  # 因为使用的最新内核，打开这个会导致更新过于频繁
  system.autoUpgrade.enable = false;

  nixpkgs.config.allowUnfree = true;
  # programs.steam.enable = true; # steam 安装

  boot.kernel.sysctl = {
    # "vm.swappiness" = 200;
    "vm.overcommit_memory" = 1;
  };

 # https://nixos.org/manual/nixos/stable/index.html#ch-file-systems
 # 这一个例子如何自动 mount 一个盘，但是配置放到 /etc/nixos/configuration.nix
 # 中，参考[1] 但是 options 只有包含一个
 # [1]: https://unix.stackexchange.com/questions/533265/how-to-mount-internal-drives-as-a-normal-user-in-nixos
 #
 #  fileSystems."/home/martins3/hack" = {
 #    device = "/dev/disk/by-uuid/b709d158-aa6a-4b72-8255-513517548111";
 #    fsType = "auto";
 #    options = [ "user" "exec" "nofail"];
 #  };

}


# 做一个开机任务，记录下 SSD 的写入
# 🧀  sudo smartctl -t short -a /dev/nvme2n1 | grep "Data Units Written"
# Data Units Written:                 220,743,742 [113 TB]
