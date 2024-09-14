{ config, pkgs, ... }:

{
  boot = {
    crashDump.enable = false; # TODO 这个东西形同虚设，无须浪费表情
    crashDump.reservedMemory = "1G";
    # nixos 的 /tmp 不是 tmpfs 的，但是我希望重启之后，/tmp 被清空
    tmp.cleanOnBoot = true;

    loader = {
      efi = {
        canTouchEfiVariables = true;
        # assuming /boot is the mount point of the  EFI partition in NixOS (as the installation section recommends).
        efiSysMountPoint = "/boot";
      };

      systemd-boot.configurationLimit = 10;

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
        devices = [ "nodev" ];
        efiSupport = true;
      };
    };
    supportedFilesystems = [ "ntfs" ];
  };
}
