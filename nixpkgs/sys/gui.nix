{ config, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    xkbOptions = "caps:swapescape";
  };

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = false;
  services.xserver.desktopManager.gnome.enable = true;

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      noto-fonts
      sarasa-gothic #更纱黑体
      source-code-pro
      hack-font
      jetbrains-mono
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
