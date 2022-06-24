{ config, pkgs, stdenv, lib, ... }:
let
  feishu = pkgs.callPackage ( pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/xieby1/nix_config/main/usr/gui/feishu.nix";
    sha256 = "0j21j29phviw9gvf6f8fciylma82hc3k1ih38vfknxvz0cj3hvlv";
  }) {};

  /* microsoft-edge-dev = pkgs.callPackage ./programs/microsoft-edge-dev.nix {}; */
  nixpkgs_unstable = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/ac608199012d63453ed251b1e09784cd841774e5.tar.gz";
    sha256 = "0bcy5aw85f9kbyx6gv6ck23kccs92z46mjgid3gky8ixjhj6a8vr";
  }) {config.allowUnfree = true;};
in
{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    tmux
    htop
    xclip
    fzf
    ripgrep
    tree
    yarn
    clang-tools
    cmake
    gnumake
    python3
    nodejs
    binutils
    gcc
    gdb
    alacritty
    tig
    go
    lsd
    xclip
    ccls
    bear
    tree
    jump
    fd
    ncdu
    delta # git
    nload # network
    neovide
    clash
    variety
    gh
    dijo
    # nix
    nix-index
    feishu
    wpsoffice
    microsoft-edge-dev
    sublime-merge
    cargo
    rustc
    # lib
    readline.dev
    SDL2.dev
    (pkgs.nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
    # wm
    rofi
    # --- ?
    feh
    compton
    picom
    polybar
    xmobar
    lemonbar
    conky
    dmenu
    # --- ?
  ];

/* reference: https://breuer.dev/blog/nixos-home-manager-neovim */
nixpkgs.overlays = [
  (import (builtins.fetchTarball {
    url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
  }))
];

programs.neovim = {
  enable = true;
  package = pkgs.neovim-nightly;
};

xdg.configFile."nvim" = {
    source = ../nvim;
    recursive = true;
};

xdg.configFile."alacritty.yml" = { source = ../conf/alacritty.yml; };

# TMP_TODO 实际上，可以逐步的将整个文件夹管理起来，也不是使用 leftwm 的管理器
xdg.configFile."leftwm/config.toml" = {
  source = ../conf/leftwm.toml;
};

home.file.tmux = {
    source = ../conf/tmux.conf;
    target = ".tmux.conf";
};

home.file.tig= {
    source = ../conf/tigrc.conf;
    target = ".tigrc";
};

/* loongson_server="loongson@10.90.50.30" */
/* alias la="ssh -X -t ${loongson_server} \"tmux attach || /usr/bin/tmux\"" */
/* alias sshfs_la="sshfs ${loongson_server}:/home/loongson ~/core/5000" */
programs.zsh = {
  enable = true;
  shellAliases = {
    sync-config="rsync --delete -avzh --filter=\"dir-merge,- .gitignore\" maritns3@10.0.2.2:~/.dotfiles ~/";
    update-sys = "sync-config && sudo nixos-rebuild switch";
    update-home = "sync-config && home-manager switch";
    px="export https_proxy=10.0.2.2:8889 && export http_proxy=10.0.2.2:8889 && export HTTPS_PROXY=10.0.2.2:8889 && export HTTP_PROXY=10.0.2.2:8889";
    q="exit";
    v="nvim";
    ls="lsd";
    m="make -j";
    gs="tig status";
    fd="fdfind";
    c="clear";
    du="ncdu";
    z="j";
    mc="make clean";
  };

  initExtra= "
    eval \"$(jump shell)\"
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=5'
  ";

    plugins = [
      {
        name = "zsh-autosuggestions";
        file = "zsh-autosuggestions.plugin.zsh";
        src = builtins.fetchGit {
          url = "https://github.com/zsh-users/zsh-autosuggestions";
          rev = "a411ef3e0992d4839f0732ebeb9823024afaaaa8";
        };
      }
    ];

  oh-my-zsh = {
    enable = true;
    plugins = [ "git" ];
    theme = "robbyrussell";
  };
};

  # allow unfree software
  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userEmail = "hubachelar@gmail.com";
    userName = "martins3";
    extraConfig = {
      # https://github.com/dandavison/delta
      # --- begin
      core = {
        editor = "nvim";
        pager = "delta";
      };
      interactive = {
      diffFilter="delta --color-only";
      };
      delta = {
        navigate="true";
        light="false";
      };
      merge={
        conflictstyle = "diff3";
      };
      diff= {
        colorMoved = "default";
      };
      # --- end

      http={
        proxy = "http://10.0.2.2:8889";
      };
      https={
        proxy = "http://10.0.2.2:8889";
      };
      credential={
        helper = "store";
      };
    };
  };

  home.file.gdbinit = {
    source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/cyrus-and/gdb-dashboard/2b107b27949d13f6ef041de6eec1ad2e5f7b4cbf/.gdbinit";
      sha256 = "02rxyk8hmk7xk1pyhnc5z6a2kqyd63703rymy9rfmypn6057i4sr";
      name = "gdbinit";
    };
    target = ".gdbinit";
  };
  home.file.gdb_dashboard_init = {
    source = ../conf/gdbinit;
    target = ".gdbinit.d/init";
  };

  home.file.cargo_conf = {
    source = ../conf/cargo.conf;
    target = ".cargo/config";
  };

  systemd.user.services.clash = {
    Unit = {
      Description = "Auto start clash";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.clash.outPath}/bin/clash";
    };
  };

  xdg.desktopEntries = {
    clash = {
      name = "clash";
      exec = "qutebrowser http://clash.razord.top";
    };
  };
}
