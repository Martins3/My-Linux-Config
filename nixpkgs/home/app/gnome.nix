# from https://github.com/xieby1/nix_config
{ config, pkgs, stdenv, lib, ... }:
# gnome extensions and settings
# no need log out to reload extension: <alt>+F2 r
{
  home.packages = (with pkgs; [
    gnome.gnome-sound-recorder
  ])
  ++ (with pkgs.gnomeExtensions; [
    unite
    clipboard-indicator
    bing-wallpaper-changer
    gtile
    hide-top-bar
    lightdark-theme-switcher
  ]);

  # Setting: `gsettings set <key(dot)> <value>`
  # Getting: `dconf dump /<key(path)>`
  dconf.settings = {
    "org/gnome/mutter" = {
      experimental-features = [ "scale-monitor-framebuffer" ];
    };

    "org/gnome/shell" = {
      ## enabled gnome extensions
      disable-user-extensions = false;
      enabled-extensions = [
        "BingWallpaper@ineffable-gmail.com"
        "clipboard-indicator@tudmotu.com"
        "gTile@vibou"
        "hidetopbar@mathieu.bidon.ca"
        "unite@hardpixel.eu"
        "theme-switcher@fthx"
      ];

      ## dock icons
      favorite-apps = [
        "microsoft-edge-dev.desktop"
      ];
    };
    ## extensions settings
    "org/gnome/shell/extensions/system-monitor" = {
      compact-display = true;
      cpu-show-text = false;
      cpu-style = "digit";
      icon-display = false;
      memory-show-text = false;
      memory-style = "digit";
      net-show-text = false;
      net-style = "digit";
      swap-display = false;
      swap-style = "digit";
    };
    "org/gnome/shell/extensions/gtile" = {
      animation = true;
      global-presets = true;
      grid-sizes = "6x4,8x6";
      preset-resize-1 = [ "<Super>bracketleft" ];
      preset-resize-2 = [ "<Super>bracketright" ];
      preset-resize-3 = [ "<Super>period" ];
      preset-resize-4 = [ "<Super>slash" ];
      preset-resize-5 = [ "<Super>apostrophe" ];
      preset-resize-6 = [ "<Super>semicolon" ];
      preset-resize-7 = [ "<Super>comma" ];
      resize1 = "2x2 1:1 1:1";
      resize2 = "2x2 2:1 2:1";
      resize3 = "2x2 1:2 1:2";
      resize4 = "2x2 2:2 2:2";
      resize5 = "4x8 2:2 3:7";
      resize6 = "1x2 1:1 1:1";
      resize7 = "1x2 1:2 1:2";
      show-icon = false;
    };

    "org/gnome/desktop/session" = {
      idle-delay = lib.hm.gvariant.mkUint32 900; # dim the screen after 15 mins
    };
    "org/gnome/settings-daemon/plugins/power" = {
      ambient-enabled = false;
      idle-dim = true;
      power-button-action = "suspend";
      # @todo suspend 之后还可以 ping 通吗？
      sleep-inactive-ac-timeout = 0 ; # suspend the machine after 1 hour
      sleep-inactive-ac-type = "suspend";
      sleep-inactive-battery-type = "suspend";
    };
    "org/gnome/shell/extensions/hidetopbar" = {
      mouse-sensitive = true;
      enable-active-window = false;
      enable-intellihide = true;
    };
    "org/gnome/shell/extensions/unite" = {
      app-menu-ellipsize-mode = "end";
      extend-left-box = false;
      greyscale-tray-icons = false;
      hide-app-menu-icon = false;
      hide-dropdown-arrows = true;
      hide-window-titlebars = "always";
      notifications-position = "center";
      reduce-panel-spacing = true;
      show-window-buttons = "always";
      window-buttons-placement = "last";
      window-buttons-theme = "materia";
      restrict-to-primary-screen = false;
    };
    "org/gnome/shell/extensions/bingwallpaper" = {
      market = "zh-CN";
      delete-previous = false;
    };

    # predefined keyboard shortcuts
    "org/gnome/desktop/wm/keybindings" = {
      switch-applications = [ ];
      switch-applications-backward = [ ];
      switch-to-application-1 = [ ];
      switch-to-application-2 = [ ];
      switch-to-application-3 = [ ];
      switch-to-application-4 = [ ];
      switch-windows = [ "<Super>Tab" ];
      switch-windows-backward = [ "<Shift><Alt>Tab" ];
      move-to-workspace-left = [ "<Control>Home" ];
      move-to-workspace-right = [ "<Control>End" ];
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Control><Alt>t";
      command = "wezterm";
      /* command = "alacritty"; */
      name = "open-terminal";
    };

    "org/gnome/shell/extensions/clipboard-indicator" =
      {
        move-item-first = true;
      };

    # nautilus
    "org/gtk/settings/file-chooser" = {
      sort-directories-first = true;
    };

    "org/gnome/desktop/interface" = {
      enable-hot-corners = true;
      show-battery-percentage = true;
    };
  };
}
