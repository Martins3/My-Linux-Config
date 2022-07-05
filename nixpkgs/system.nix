# add this file to /etc/nixos/configuration.nix: imports
{ config, pkgs, ... }:

{
  # TMP_TODO i think there's no need to include gui.nix
  # 非常神奇，如果含有 gui.nix 之后，那么就会 UI 界面
  imports = [
    ./sys/cli.nix
    /* ./sys/gui.nix */
  ];

  nix.binaryCaches = [
    "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
    "https://cache.nixos.org/"
  ];

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";
  time.hardwareClockInLocalTime = true;

  programs.zsh.enable = true;

  virtualisation.docker.enable = true;

  users.extraUsers.martins3 = {
      isNormalUser = true;
      shell = pkgs.zsh;
      home = "/home/martins3";
      # TMP_TODO 补充文档
      # https://stackoverflow.com/questions/51342810/how-to-fix-dial-unix-var-run-docker-sock-connect-permission-denied-when-gro
      extraGroups = [ "wheel" "docker" ];
  };
}
