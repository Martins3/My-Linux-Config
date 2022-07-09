{ config, pkgs, stdenv, lib, ... }:

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
    go
    lua
    gdb
    tig
    lsd
    lsof
    ccls
    xclip
    bear
    tree
    jump
    fd
    cloc
    file
    ncdu
    delta # git
    # network
    nload
    iftop
    gh
    tcpdump
    # nix
    nix-index
    cargo
    rustc
    # lib
    readline.dev
    SDL2.dev
    (pkgs.nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
    # kernel
    flex
    bison
    # qemu
    qemu
    qemu-utils
    ninja
    libvirt
    virt-manager
    # vim
    shellcheck
    shfmt
    # linux
    bison
    flex
    lzop
    pkgconfig
    ncurses
    openssl
    elfutils # TMP_TODO 似乎 Nix 中的库总是需要依赖一下 default.nix 的
    bc
    # tlpi
    libcap
    acl
    # trace
    perf-tools
    iperf
  ];
  # TMP_TODO 我的是非常迷茫啊
/* nix-shell -p linuxKernel.packages.linux_5_18.perf --command zsh */


/* reference: https://breuer.dev/blog/nixos-home-manager-neovim */
# TMP_TODO 调查一下，这是个什么原理?
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
    source = ../../nvim;
    recursive = true;
};


home.file.tmux = {
    source = ../../conf/tmux.conf;
    target = ".tmux.conf";
};

home.file.tig= {
    source = ../../conf/tigrc.conf;
    target = ".tigrc";
};

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
      # @todo 增加这个 plugin 吧 https://github.com/Aloxaf/fzf-tab
    ];

  oh-my-zsh = {
    enable = true;
    plugins = [ "git" ];
    theme = "robbyrussell";
  };
};

# TMP_TODO 应该设置 npm 的 register 一下

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

      # TMP_TODO : make this a configuration
      /*
      http={
        proxy = "http://10.0.2.2:8889";
      };
      https={
        proxy = "http://10.0.2.2:8889";
      };
      */
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
    source = ../../conf/gdbinit;
    target = ".gdbinit.d/init";
  };

  home.file.cargo_conf = {
    source = ../../conf/cargo.conf;
    target = ".cargo/config";
  };
}
