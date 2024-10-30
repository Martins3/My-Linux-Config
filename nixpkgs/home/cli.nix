{ config, pkgs, stdenv, lib, ... }:

let
  unstable = import <unstable> { };

    # tmux 最近的鼠标拖动会很卡
    wopkgs = import (builtins.fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/53951c0c1444e500585205e8b2510270b2ad188f.tar.gz";
    }) {};

    myPkg = wopkgs.tmux;
in
{
  fonts.fontconfig.enable = true;

  home.stateVersion = "23.11";
  home.username = "martins3";
  home.homeDirectory = "/home/martins3";

  home.packages = with pkgs; [
    strace
    vim
    git
    gcc
    libgcc # gcov
    libclang # 各种 clang 基本工具，例如 clang-doc
    libllvm
    lld
    # gnuplot
    ccache
    opam
    # mold
    spin swarm # 形式化验证工具
    hdparm
    go
    ruby
    ouch # 简化压缩/解压缩的使用
    unstable.serpl # nvim 中的集成
    # gitea # 好吧，还需要手动搭建数据库才可以
    sipcalc
    ventoy
    novnc
    postman # 不会用
    grpcurl
    # uutils-coreutils # @todo 到时候尝试下 rust 的 coreutils
    lua
    # zfs
    # 文件浏览器
    # xplr

    pass # wireguard 作者维护的密码管理工具
    lua-language-server
    stylua
    # TODO virt-customize -a bionic-server-cloudimg-amd64.img --root-password password:<pass>
    # libguestfs
    # libguestfs-appliance
    # cloud-utils
    adoptopenjdk-icedtea-web # 用于打开 impi jnlp 文件
    ccls
    checkmake
    # minicom
    typos # 检查代码中 typo
    # typst # latex 替代品
    # include-what-you-use # 很小的项目都用着不正常
    cargo
    cmake
    # ov # feature rich pager
    # zig
    dracut
    iw
    termshark
    openvswitch-lts
    dnsmasq
    gnumake
    # audit # 没啥意义，用不起来
    yarn
    nodejs
    tmux
    # myPkg
    tmuxp
    pueue
    screen
    clash-meta
    tig
    gitui
    xclip # x clipboard
    # wl-clipboard # wayland clipboard
    jq
    aspell
    aspellDicts.en
    # yq-go
    htop
    btop
    unzip
    fzf
    ripgrep
    binutils
    starship
    gdb
    lsof
    lshw # 侧重于展示 bus 的结构
    hwloc # 侧重于展示 cache
    hw-probe #  sudo -E hw-probe -all -upload
    eza # more powerful ls
    # oh-my-posh # @todo for powershell
    # gource
    fastfetch
    bear
    tree
    fd
    file
    duf # 更好的 df -h
    zoxide # better jump
    # ncdu # 更加易用的 du
    gdu
    # du-dust # 方便找大文件
    socat # unix domain
    delta # git diff
    act # Run github action locally
    # git-secrets
    nethogs
    bandwidth
    # openfortivpn # TODO 真的可以用吗?
    # sniffnet # 一个直接简单易用的
    nmap
    conntrack-tools # 分析 conntrack 表
    # dhcpcd # 这个东西和 nixos 不兼容
    iftop
    # neomutt # 邮件列表，很难用
    b4
    # weechat
    # offlineimap # 下载邮件的工具，很难用
    tcpdump
    ethtool
    proxychains-ng
    sshpass
    gping # better ping
    pingu # interesting ping
    # frp # 反向代理
    nbd
    kmon # 方便的管理内核模块
    numactl
    # numatop # CPU 根本不支持
    # kexec-tools # 实际上没有办法用
    rpm
    stress-ng
    # OVMFFull # 存储在 /run/libvirt/nix-ovmf/ 下
    # 通过 tweaks 调整开机自启动
    gnome3.gnome-tweaks # @todo 确定是这里设置的，还是只是一个 extension
    hexyl # 分析二进制
    # rasdaemon # @todo 莫名其妙，不知道怎么使用
    nvme-cli
    ninja
    libvirt # 提供 virsh
    qemu
    # lima # 虚拟机工具
    virt-manager
    # quickemu
    # unstable.nixos-shell
    krunvm  # 有待尝试
    # nixpacks
    nix-tree # 动态的展示每一个包的依赖
    # buildah
    virtiofsd
    # podman
    # podman-tui
    # k9s
    # minikube
    # minio
    # dufs # 一个全新的 ftp server
    # hoard # 暂时不知道怎么使用
    # slirp4netns
    # nix-index
    # nixd
    # debootstrap # 制作 uml 的工具
    meson
    neovim
    # zed-editor # 默认不支持中文，放弃
    # helix # modern neovim
    # cheat
    # wakatime
    shellcheck
    shfmt
    tree-sitter
    systeroid
    # linuxKernel.packages.linux_5_15.perf
    linuxPackages_6_10.perf
    linuxPackages_6_10.kernel.dev # TODO 怎么将内核和 nixpkgs/sys/kernel-options.nix 放到一起
    # 没法用，还需要内核模块
    # error opening device /dev/scap0. Make sure you have root credentials and that the scap module is loaded: No such file or directory
    linuxPackages_6_10.sysdig

    # cflow # 感觉很弱，没用懂
    iperf
    # linuxPackages_latest.systemtap # 似乎这个让 libvirt 的编译开始依赖 systemdtab 的头文件了
    # 其实也不能用
    # ERROR: kernel release isn't found in "/nix/store/n3nrix9pc0m1ywzg8dq71bh2xr82c7l5-linux-6.3.5-dev"
    # 还是在虚拟机勉强维持生活吧
    bpftrace
    blktrace
    # kernelshark
    trace-cmd
    # hotspot
    # heaptrack
    coccinelle
    ltrace # library trace
    bcc
    bpftool
    procps
    xdp-tools
    acpi
  ] ++ pkgs.lib.optionals (builtins.currentSystem=="x86_64-linux") [
    auto-cpufreq
    cpuid
    # linuxKernel.packages.linux_latest_libre.turbostat
    pcm
    # zenith-nvidia # 用处不大，和 top 功能重叠
    nvitop # 美观，比 nvidia-smi 好用
    powertop # 分析功耗
  ] ++ [
    # @todo https://github.com/kkharji/sqlite.lua/issues/28
    # 需要设置 libsqlite3.so 的位置
    sqlite
    parted
    sysbench
    # wirelesstools
    dos2unix
    # @todo 传统调试工具专门整理为一个包
    sysstat # sar, iostat and pidstat mpstat
    # dpdk
    # firecracker
    inetutils
    (python3.withPackages (p: with p; [
      ipython
      autopep8
      gcovr
      pygments # 让 gdb-dashboard 支持高亮
      pytest
    ]))
    # ruff # 类似 pyright，据说很快，但是项目太小，看不出什么优势
    # perl
    man-pages
    pre-commit
    atop # 类似 htop ，但是展示的内容不同
    nmon
    man-pages-posix
    lazydocker
    docker-compose
    runc
    crun
    youki
    openssl
    distrobox # 基于容器来提供各种 distribution
    boxbuddy # distrobox 的图形工具
    minicom
    arp-scan
    # nixos-generators # 基于当前系统生成 qcow2
    packer # 制作 qcow2 镜像
    gum
    # acpi
    acpica-tools
    asciidoc
    libiscsi
    # openiscsi
    lsscsi
    sg3_utils # 提供 scsi_logging_level
    targetcli
    fio
    genact # A nonsense activity generator
    # wtf # The personal information dashboard for your terminal
    progress # 展示 cp dd 之类的进度条
    psmisc # 包含 pstree fuser 等工具
    viddy # A modern watch command.
    # mcfly # better ctrl-r for shell
    atuin
    pciutils
    usbutils
    cyme # 一个更加好看的 usbutils
    # lm_sensors # 获取 CPU 温度，但是 btop 差不多可以了
    libxfs # @todo 使用 sudo mkfs.xfs -f /dev/sda1 还是需要 nix-shell -p libxfs
    bcachefs-tools
    libcgroup
    cpulimit
    # bat # better cat
    # procs # better ps ，但是 ps 才是 yyds
    tokei # 代码统计工具，比 cloc 性能好
    zellij # tmux 替代品
    # kvmtool
    # just # 在对应的目录中自定义执行命令
    # (import (fetchTarball https://install.devenv.sh/latest)).default # 浪费人生宝贵的 2h ，不明觉厉
    # devenv # 需要配置 nix cache ，感觉完全不靠谱啊
    # @todo 不知道为什么，这种方法不行
    # (import (fetchTarball https://github.com/blitz/x86-manpages-nix/archive/master.tar.gz))
    bridge-utils
    swtpm # windows 11 启动需要
    # nushell
    # powershell
    # vector
    dmidecode # sudo dmidecode -t 1
    git-review

    # containerd # @todo 测试下
    # nerdctl
    pwru # ebpf 抓包工具
    calcure # 日历，@todo 可以定制化的，有趣
    pahole

    # openjdk
    # dockerTools @todo # 使用 nixos 构建 docker
    # https://nixos.org/manual/nixpkgs/stable/#sec-pkgs-dockerTools
    asciiquarium
    bc # bash 数值计算
    bash_unit

    # cowsay
    # figlet # 艺术字
    # lolcat # 彩虹 cat
    # nyancat # 彩虹猫咪

    dig # dns 分析
    iptraf-ng # 网络流量分析
    ifmetric
    glances # 又一个 htop

    smartmontools # 监视硬盘健康
    # httpie # http baidu.com

    lcov

    # czkawka # 垃圾文件清理
    ipmitool

    # cachix # nixos 的高级玩法，自己架设 binary cache

    # lsp && formatter
    black # python formatter
    rust-analyzer
    rustfmt
    efm-langserver # 集成 shellcheck
    marksman
    nodePackages.pyright
  ];

  programs.zsh = {
    enable = true;
    shellAliases = { };
    initExtra = "
    source /home/martins3/.dotfiles/config/zsh
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

  home.file.gitconfig = {
    source = ../../config/gitconfig;
    target = ".gitconfig";
  };

  home.file.gdbinit = {
    source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/cyrus-and/gdb-dashboard/master/.gdbinit";
      sha256 = "1chhyk7rhm1ysbdi4rzmik25cdfyv4kmgzx70yfgsxr9cjw4kllb";
      name = "gdbinit";
    };
    target = ".gdbinit";
  };

  home.file.gdb_dashboard_init = {
    source = ../../config/gdbinit;
    target = ".gdbinit.d/init";
  };

  home.file.npm = {
    source = ../../config/npmrc;
    target = ".npmrc";
  };

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
}
