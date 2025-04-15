{ config, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    xkb.options = "caps:swapescape";
    # 暂时可以使用这个维持生活吧
    # gsettings set org.gnome.desktop.input-sources xkb-options "['caps:swapescape']"
    # https://nixos.org/manual/nixos/stable/index.html#sec-gnome-gsettings-overrides
  };

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = false;
  services.xserver.desktopManager.gnome.enable = true;

  # see xieby1
  fonts.packages = (
    with (import (fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/d881cf9fd64218a99a64a8bdae1272c3f94daea7.tar.gz";
      sha256 = "1jaghsmsc05lvfzaq4qcy281rhq3jlx75q5x2600984kx1amwaal";
    }) {}); [
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-emoji]) ++ (with pkgs; [
    (nerdfonts.override {
      fonts = [
        "SourceCodePro"
        "Iosevka"
        "FiraCode"
        "FantasqueSansMono"
      ];
    })
    # refs to pkgs/data/fonts/roboto-mono/default.nix
    (stdenv.mkDerivation {
      name = "my_fonts";
      srcs = [(fetchurl {
        url = "https://github.com/lxgw/LxgwWenKai/releases/download/v1.315/LXGWWenKaiMono-Bold.ttf";
        sha256 = "129ikb5d9gqcy801rqqsirqjmz24mgshcc6mgj65bq6w6abs3y7y";
      }) (fetchurl {
        url = "https://github.com/lxgw/LxgwWenKai/releases/download/v1.315/LXGWWenKai-Regular.ttf";
        sha256 = "1ybzbk50l3lmz0aja9cjh40bxcx9py8349qabxplpispk5jyy76d";
      })];
      sourceRoot = "./";
      unpackCmd = ''
        ttfName=$(basename $(stripHash $curSrc))
        cp $curSrc ./$ttfName
      '';
      installPhase = ''
        mkdir -p $out/share/fonts/truetype
        cp -a *.ttf $out/share/fonts/truetype/
      '';
    })
  ]);


  fonts.fontDir.enable = true;
  fonts.fontconfig.defaultFonts = {
    monospace = [
      "DejaVu Sans Mono"
      "Noto Color Emoji"
      "Noto Emoji"
    ];
  };

  # 解决 kitty 和 wezterm 无法使用 fcitx5 输入法的问题
  # https://github.com/kovidgoyal/kitty/issues/403
  environment.variables.GLFW_IM_MODULE = "ibus";
  i18n.inputMethod.enable = true;
  i18n.inputMethod.type = "ibus";
  i18n.inputMethod.ibus.engines = with pkgs.ibus-engines; [
    rime
  ];

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


}
