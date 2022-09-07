{ config, pkgs, stdenv, lib, ... }:

let
  unstable = import <unstable> { };
in
{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    # compiler && builder
    autoconf
    automake
    gcc
    go
    lua
    clang-tools
    cargo
    rustc
    rust-analyzer
    cmake
    gnumake
    yarn
    nodejs
    # tmux
    tmux
    tmuxinator
    tig
    # cli tools
    xclip
    jq
    htop
    # search
    fzf
    ripgrep
    silver-searcher
    binutils
    gdb
    lsd
    lsof
    ccls
    bear
    tree
    jump
    fd
    cloc
    file
    ncdu
    socat # unix domain
    # git
    delta
    git-secrets
    gh
    # network
    nethogs
    iftop
    tcpdump
    ethtool
    sshpass
    gping
    # nix
    nix-index
    # lib
    readline.dev
    SDL2.dev
    # kernel
    numactl
    kexec-tools
    rpm
    stress
    # numastat TMP_TODO 如何安装这个包
    # qemu
    # OVMF # 安装了，但是 OVMF.fd 没有找到
    qemu
    qemu-utils
    ninja
    libvirt
    virt-manager
    meson
    # vim
    neovim
    shellcheck
    shfmt
    rnix-lsp
    tree-sitter
    # tlpi # TMP_TODO 既没有找到正确的 tlpi，也无法将所有的 tlpi 都编译成功。
    libcap
    acl
    # trace
    pkgs.linuxPackages_latest.perf
    iperf
    bpftrace
    sysstat
    # dpdk
    dpdk
    # python
    (python3.withPackages (p: with p; [
      pandas
      pygal
      pre-commit
      pypinyin
      ipython
      filelock
    ]))
    man-pages
    man-pages-posix
    # x86-manpages 不知道如何安装
    lazydocker
    # TMP_TODO 在处理 efivar 的编译的时候，引入这个，但是似乎有问题
    /* mandoc */
    nixos-generators
    unstable.gum
    # acpi
    acpica-tools
    asciidoc
    # fun
    genact
    czkawka
  ];

  home.file.".tmux/plugins/tpm" = {
    source = builtins.fetchGit {
      url = "https://github.com/tmux-plugins/tpm";
      rev = "b699a7e01c253ffb7818b02d62bce24190ec1019"; # updated at 2022/7/17
    };
  };

  /*
    xdg.configFile."nvim" = {
    source = ../../nvim;
    recursive = true;
    };
  */

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
      px = "export https_proxy=10.0.2.2:8889 && export http_proxy=10.0.2.2:8889 && export HTTPS_PROXY=10.0.2.2:8889 && export HTTP_PROXY=10.0.2.2:8889";
      q = "exit";
      v = "nvim";
      ls = "lsd";
      ldc = "lazydocker";
      m = "make -j";
      gs = "tig status";
      c = "clear";
      du = "ncdu";
      z = "j";
      mc = "make clean";
      k = "/home/martins3/Sync/vn/docs/qemu/sh/alpine.sh";
      en_direnv = "echo \"use nix\" >> .envrc && direnv allow";
      env_docker = "docker run -it --rm -u $(id -u):$(id -g) -v $(pwd):/home/martins3/src"; # kernel-build-container:gcc-7
      knews = "~/.dotfiles/scripts/systemd/news.sh kernel";
      qnews = "~/.dotfiles/scripts/systemd/news.sh qemu";
      ck = "systemctl --user start kernel";
      cq = "systemctl --user start qemu";
    };

    # TMP 这样写是非常不优雅的
    initExtra = "
    eval \"$(jump shell)\"
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=5'
    eval \"$(direnv hook zsh)\"

    function edward() {
      pinyin=$(pypinyin -s NORMAL $1)
      printf \"%s\t%s\t1\n\" \"$1\" \"$pinyin\" >> ~/.dotfiles/rime/luna_pinyin.martins3.dict.yaml
    }

    function gscp() {
      file_name=$1
      if [ -z \"file_name\" ]; then
        echo $0 file
        return 1
      fi
      ip=$(ip a | grep -v vir | grep -o \"192\..*\" | cut -d/ -f1)
      file_path=$(readlink -f $file_name)
      echo scp -r $(whoami)@\${ip}:$file_path .
    }

    function rpm_extract() {
      rpm2cpio $1 | cpio -idmv
    }
    ";
    # 增加一个这个
    # ln -sf ~/.dotfiles/scripts/nix/env/shim.nix default.nix

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

      alias = {
        # 查询一个 merge commit 中的数值
        # https://stackoverflow.com/questions/6191138/how-to-see-commits-that-were-merged-in-to-a-merge-commit
        log-merge = "!f() { git log --oneline --graph --stat \"$1^..$1\"; }; f";
        # 优雅的打印
        # https://stackoverflow.com/questions/6191138/how-to-see-commits-that-were-merged-in-to-a-merge-commit
        adog = "log --all --decorate --oneline --graph";
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

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
}
