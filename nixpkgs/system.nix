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

  users.mutableUsers = false;
  users.users.martins3 = {
    isNormalUser = true;
    shell = pkgs.zsh;
    # shell = pkgs.nushell;
    home = "/home/martins3";
    extraGroups = [ "wheel" "docker" "libvirtd" ];
  };



  # https://nixos.wiki/wiki/Fwupd
  # 似乎没啥用，而且还是存在 bug 的
  services.fwupd.enable = false;

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

  # sudo systemctl status systemd-oomd.service
  # sudo journalctl -u systemd-oomd.service
  # @todo services 和 systemd 的差别是什么?
  systemd.oomd.enable = true;
  services.irqbalance.enable = false; # 将其自动 disable 掉

  # 使用方法 : sudo lldpcli show neighbor
  services.lldpd.enable = true;

  # @todo 使用下吧
  system.autoUpgrade.enable = false;

  nixpkgs.config.allowUnfree = true;
  # programs.steam.enable = true; # steam 安装

  nix.settings.experimental-features = "nix-command flakes";
  # 因为使用的最新内核，打开这个会导致更新过于频繁
}


# 做一个开机任务，记录下 SSD 的写入
# 🧀  sudo smartctl -t short -a /dev/nvme2n1 | grep "Data Units Written"
# Data Units Written:                 220,743,742 [113 TB]
