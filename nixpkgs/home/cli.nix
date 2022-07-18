{ config, pkgs, stdenv, lib, ... }:

let

in
{

  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    # TMP_TODO 原理需要深入分析
    # https://unix.stackexchange.com/questions/646319/how-do-i-install-a-tarball-with-home-manager
    rnix-lsp
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
    numactl
    # numastat TMP_TODO 如何安装这个包
    # qemu
    qemu
    qemu-utils
    ninja
    libvirt
    virt-manager
    meson
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
    # dpdk
    dpdk
  ];
  # TMP_TODO 我的是非常迷茫啊，为什么不能自动安装内核对应的 perf 版本。
  /* nix-shell -p linuxKernel.packages.linux_5_18.perf --command zsh */


  /* reference: https://breuer.dev/blog/nixos-home-manager-neovim */
  # TMP_TODO 调查一下，这是个什么原理?
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
    }))
  ];

  # TMP_TODO 2022/7/15 的时候无法正确编译了
  # 暂时使用这个安装，也不知道这个安装是个什么含义的。
  # https://search.nixos.org/packages?channel=22.05&show=neovim&from=0&size=50&sort=relevance&type=packages&query=neovim
  /*
    programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;
    };
  */

  xdg.configFile."nvim" = {
    source = ../../nvim;
    recursive = true;
  };

  # TMP_TODO tpm 通过 github 下载，其他插件需要使用 prefix I 来下载，也许存在更好的方法
  home.file.".tmux/plugins/tpm" = {
    source = builtins.fetchGit {
      url = "https://github.com/tmux-plugins/tpm";
      rev = "b699a7e01c253ffb7818b02d62bce24190ec1019"; # updated at 2022/7/17
    };
  };

  home.file.tmux = {
    source = ../../conf/tmux.conf;
    target = ".tmux.conf";
  };

  home.file.tig = {
    source = ../../conf/tigrc.conf;
    target = ".tigrc";
  };

  programs.zsh = {
    enable = true;
    shellAliases = {
      sync-config = "rsync --delete -avzh --filter=\"dir-merge,- .gitignore\" maritns3@10.0.2.2:~/.dotfiles ~/";
      update-sys = "sync-config && sudo nixos-rebuild switch";
      update-home = "sync-config && home-manager switch";
      ns = "nix-shell --command zsh"; # TMP_TODO 没有更好的方法吗，有 nix-shell 和没有会导致 linux 重新索引，应该一开始就提醒的
      px = "export https_proxy=10.0.2.2:8889 && export http_proxy=10.0.2.2:8889 && export HTTPS_PROXY=10.0.2.2:8889 && export HTTP_PROXY=10.0.2.2:8889";
      q = "exit";
      v = "nvim";
      ls = "lsd";
      m = "make -j";
      gs = "tig status";
      c = "clear";
      du = "ncdu";
      z = "j";
      mc = "make clean";
    };

    initExtra = "
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
        diffFilter = "delta --color-only";
      };
      delta = {
        navigate = "true";
        light = "false";
      };
      merge = {
        conflictstyle = "diff3";
      };
      diff = {
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
      credential = {
        helper = "store";
      };
    };
  };

  # TMP_TODO 需要自动安装 https://pre-commit.com/
  # 以及中文的检测工具: https://github.com/lint-md/cli
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
