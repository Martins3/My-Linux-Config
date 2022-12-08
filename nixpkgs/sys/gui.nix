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
  fonts.fonts = with pkgs; [
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-emoji
    (nerdfonts.override {
      fonts = [
        "SourceCodePro"
        "Iosevka"
        "FiraCode"
        "FantasqueSansMono"
      ];
    })

    (stdenv.mkDerivation {
      name = "my_fonts";
      srcs = [
        (fetchurl {
          url = "https://github.com/lxgw/LxgwWenKai/releases/download/v1.235.2/LXGWWenKai-Bold.ttf";
          sha256 = "1v7bczjnadzf2s8q88rm0pf66kaymq3drsll4iy3i5axpbimap18";
        })
        (fetchurl {
          url = "https://github.com/lxgw/LxgwWenKai/releases/download/v1.235.2/LXGWWenKai-Regular.ttf";
          sha256 = "06kpqgar0vvsng4gzsnj1app1vkv7v07yqgi5mfwzxch0di5qk3v";
        })
      ];
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
  ];

  fonts.fontDir.enable = true;
  fonts.fontconfig.defaultFonts = {
    monospace = [
      "DejaVu Sans Mono"
      "Noto Color Emoji"
      "Noto Emoji"
    ];
  };

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx.engines = with pkgs.fcitx-engines; [ rime ];
    fcitx5.enableRimeData = true;
    fcitx5.addons = with pkgs; [
      fcitx5-rime
    ];
  };
}
