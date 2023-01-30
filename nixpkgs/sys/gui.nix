{ config, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    xkbOptions = "caps:swapescape";
  };

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = false;
  services.xserver.desktopManager.gnome.enable = true;

  # see xieby1
  fonts.fonts = (
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
        url = "https://github.com/lxgw/LxgwWenKai/releases/download/v1.235.2/LXGWWenKai-Bold.ttf";
        sha256 = "1v7bczjnadzf2s8q88rm0pf66kaymq3drsll4iy3i5axpbimap18";
      }) (fetchurl {
        url = "https://github.com/lxgw/LxgwWenKai/releases/download/v1.235.2/LXGWWenKai-Regular.ttf";
        sha256 = "06kpqgar0vvsng4gzsnj1app1vkv7v07yqgi5mfwzxch0di5qk3v";
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

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx.engines = with pkgs.fcitx-engines; [ rime ];
    fcitx5.enableRimeData = true;
    fcitx5.addons = with pkgs; [
      fcitx5-rime
    ];
  };
}
