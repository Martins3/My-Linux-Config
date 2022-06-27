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

  programs.zsh.enable = true;

  users.extraUsers.martin = {
      isNormalUser = true;
      shell = pkgs.zsh;
      home = "/home/martin";
      extraGroups = [ "wheel" ];
  };

  services.xserver = {
    enable=true;
    xkbOptions = "caps:swapescape";

    /**
    desktopManager = {
      xterm.enable = false;
    };

    displayManager = {
        defaultSession = "none+i3";
    };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu #application launcher most people use
        i3status # gives you the default i3 status bar
        i3lock #default i3 screen locker
        i3blocks #if you are planning on using i3blocks over i3status
     ];
    };
    */

    /*
    # leftwm begin
    desktopManager = {
      xterm.enable = false;
    };

    displayManager = {
        defaultSession = "none+leftwm";
    };

    windowManager.leftwm = {
      enable = true;
    };
    # leftwm end
    */

    /*
    # awesome begin
    desktopManager = {
      xterm.enable = false;
    };

    displayManager = {
        defaultSession = "none+awesome";
    };

    windowManager.awesome = {
      enable = true;
    };
    # awesome end
    */
  };

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      noto-fonts
      sarasa-gothic  #更纱黑体
      source-code-pro
      hack-font
      jetbrains-mono
    ];
  };

  i18n.inputMethod = {
     enabled = "fcitx5";
     fcitx5.addons = with pkgs; [
       fcitx5-rime
     ];

    # 我现在用 ibus
    /* enabled = "ibus"; */
    /* ibus.engines = with pkgs.ibus-engines; [ */
    /*   libpinyin */
    /*   rime */
    /* ]; */
  };
}
