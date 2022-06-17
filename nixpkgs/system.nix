# add this file to /etc/nixos/configuration.nix: imports
{ config, pkgs, ... }:

{
  imports = [
    # ./sys/cli.nix
    # ./sys/gui.nix
  ];

  nix.binaryCaches = [
    "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
    "https://cache.nixos.org/"
  ];

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";
  time.hardwareClockInLocalTime = true;

  users.extraUsers.martin = {
      isNormalUser = true;
      home = "/home/martin";
      extraGroups = [ "wheel" ];
  };
}
