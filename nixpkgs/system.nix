# add this file to /etc/nixos/configuration.nix: imports
{ config, pkgs, ... }:

{
  # TMP_TODO i think there's no need to include gui.nix
  imports = [
    ./sys/cli.nix
    ./sys/gui.nix
  ];

  nix.binaryCaches = [
    "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
    "https://cache.nixos.org/"
  ];

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";
  time.hardwareClockInLocalTime = true;

  programs.zsh.enable = true;

  users.extraUsers.martin3 = {
      isNormalUser = true;
      shell = pkgs.zsh;
      home = "/home/martin3";
      extraGroups = [ "wheel" ];
  };
}
