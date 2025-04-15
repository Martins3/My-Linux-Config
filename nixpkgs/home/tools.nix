# ~/.dotfiles/nixpkgs/home/packages.nix
{ pkgs }:

let
  unstable = import <unstable> { };

  # tmux 最近的鼠标拖动会很卡
  tmux_pkgs = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/53951c0c1444e500585205e8b2510270b2ad188f.tar.gz";
  }) { };
  old_tmux = tmux_pkgs.tmux;

  # qemu_pkgs = import (builtins.fetchTarball {
  #   url = "https://github.com/NixOS/nixpkgs/archive/d1c3fea7ecbed758168787fe4e4a3157e52bc808.tar.gz";
  # }) { };
  # qemu6 = qemu_pkgs.qemu_full;

in
with pkgs;
[
  vim
  gnumake
  yarn
  nodejs
  starship
  atuin
  eza # more powerful ls
  git
  tig
  gcc
  libclang # 各种 clang 基本工具，例如 clang-doc
  libllvm
  lld
  # gnuplot
  ccache
  opam
  moreutils # jq 无法本地修改，提供 sponge
  unstable.yazi
  # mold
  spin
  swarm # 形式化验证工具
  bat
  go
  # ruby
  # procdump 微软的 ProcDump 的 linux 移植
  ouch # 简化压缩/解压缩的使用
  # xpipe # 管理服务器的工具
  # gitea # 好吧，还需要手动搭建数据库才可以
  sipcalc # ip 计算
  rsync
  novnc
  # postman # 不会用，API 工具
  # grpcurl # rpc 相关
  # uutils-coreutils # @todo 到时候尝试下 rust 的 coreutils
  lua
  # zfs
  # 文件浏览器
  # xplr

  pass # wireguard 作者维护的密码管理工具
  # TODO virt-customize -a bionic-server-cloudimg-amd64.img --root-password password:<pass>
  # libguestfs
  # libguestfs-appliance
  # cloud-utils
  # adoptopenjdk-icedtea-web # 用于打开 impi jnlp 文件
  # minicom
  typos # 检查代码中 typo
  # typst # latex 替代品
  # include-what-you-use # 很小的项目都用着不正常
  cargo
  cmake
  # ov # feature rich pager
  # zig
  zstd
  termshark
  dnsmasq
  # audit # 没啥意义，用不起来
  # tmux
  old_tmux
  tmuxp
  pueue
  screen
  gitui
  jq
  # yq-go
  htop
  # glances # 又一个 htop
  btop
  unzip
  fzf
  ripgrep
  # TODO 似乎这个 binutils 真的是多余的，但是为什么只有到 mac 上才发现
  # binutils
  lsof
]
++ pkgs.lib.optionals (stdenv.isLinux) [
  # ceph
  # 真的奇怪，ceph 和 bcc 居然用冲突
  bcc
  nvme-cli

  kmon # 方便的管理内核模块
  numactl
  # numatop # CPU 根本不支持
  # kexec-tools # 实际上没有办法用
  rpm

  ethtool
  conntrack-tools # 分析 conntrack 表
  # dhcpcd # 这个东西和 nixos 不兼容
  nethogs
  systeroid
  xclip # x clipboard
  # wl-clipboard # wayland clipboard
  aspell
  aspellDicts.en

  dracut
  ventoy
  gdb
  # iw # TODO 做啥的来着

  # busybox # 提供 devmem 等工具，但是会覆盖很多工具
  debootstrap # 制作 rootfs 的工具
  fakeroot

  libgcc # gcov

  ipmitool
  hdparm
  smartmontools # 监视硬盘健康
  lshw # 侧重于展示 bus 的结构
  hwloc # 侧重于展示 cache
  hw-probe # sudo -E hw-probe -all -upload
  # linuxKernel.packages.linux_5_15.perf
  # linuxPackages.perf
  linuxKernel.packages.linux_6_12.perf
  gperftools # 主要提供 pprof 功能，但是没用过
  # TODO 怎么将内核和 nixpkgs/sys/kernel-options.nix ，而且 kernel.dev 做啥用的
  # linuxPackages_6_10.kernel.dev

  # 没法用，还需要内核模块
  # error opening device /dev/scap0. Make sure you have root credentials and that the scap module is loaded: No such file or directory
  # linuxPackages_6_10.sysdig

  # cflow # 感觉很弱，没用懂
  strace

  pahole
  xdp-tools
  acpi
  bpftrace
  # blktrace
  bpftools
  bpftune
  pwru # ebpf 抓包工具
  # kernelshark
  trace-cmd
  # hotspot
  # heaptrack
  coccinelle

  # acpi
  acpica-tools
  libiscsi
  openiscsi
  lsscsi
  sg3_utils # 提供 scsi_logging_level
  targetcli

  # podman # 暂时不需要
  # podman-tui
  # minio
  # kubeadm
  # slirp4netns
  # runc
  # crun
  # youki
  # kind
  # 需要的话，打开这几个看看
  # k9s
  # kubectl
  # kubernetes-helm
  # minikube

  # openvswitch-lts # 通过 nixpkgs/sys/cli.nix 安装
  bridge-utils

  # TODO 谁包含了 ceph
  # qemu
  # qemu6
  # lima # 虚拟机工具
  # libvirt # 提供 virsh
  # virt-manager # TODO 这个是图形程序吧?
  # quickemu
  # krunvm # 有待尝试
  # unstable.nixos-shell

  # buildah
  virtiofsd
  # nixpacks

  # 想不到 ltrace macos 不支持
  ltrace # library trace

  parted
  sysbench

  sysstat # sar, iostat and pidstat mpstat
  atop # 类似 htop ，但是展示的内容不同
  # TODO 做什么的
  # nmon

  psmisc # 包含 pstree fuser 等工具

  usbutils
  cyme # 一个更加好看的 usbutils

  # lm_sensors # 获取 CPU 温度，但是 btop 差不多可以了

  # @todo 使用 sudo mkfs.xfs -f /dev/sda1 还是需要 nix-shell -p libxfs
  # nixos 有这个问题，如果只是安装 home-manger 没有这个问题
  libxfs
  # bcachefs-tools
  libcgroup
  cpulimit

  dmidecode # sudo dmidecode -t 1

  iptraf-ng # 网络流量分析
  ifmetric
]
++ [
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
  icdiff
  # git-filter-repo # 批量修改历史
  # act # Run github action locally
  # git-secrets
  bandwidth
  # openfortivpn # TODO 真的可以用吗?
  # sniffnet # 一个直接简单易用的
  nmap
  iftop
  # neomutt # 邮件列表，很难用
  b4
  # weechat
  # offlineimap # 下载邮件的工具，很难用
  tcpdump
  proxychains-ng
  sshpass
  gping # better ping
  pingu # interesting ping
  # frp # 反向代理
  nbd
  stress-ng
  # OVMFFull # 存储在 /run/libvirt/nix-ovmf/ 下
  hexyl # 分析二进制
  hyperfine # 命令行性能测试工具
  # rasdaemon # @todo 莫名其妙，不知道怎么使用
  ninja

  nix-tree # 动态的展示每一个包的依赖
  # nix-index
  nixd # nix 语言的 lsp
  nixfmt-rfc-style
  # debootstrap # 制作 uml 的工具
  meson
  neovim
  luarocks
  # zed-editor # 默认不支持中文，放弃
  # helix # modern neovim
  # cheat
  # wakatime
  shellcheck
  shfmt
  tree-sitter
  iperf
  # linuxPackages_latest.systemtap # 似乎这个让 libvirt 的编译开始依赖 systemdtab 的头文件了
  # 其实也不能用
  # ERROR: kernel release isn't found in "/nix/store/n3nrix9pc0m1ywzg8dq71bh2xr82c7l5-linux-6.3.5-dev"
  # 还是在虚拟机勉强维持生活吧
  procps
]
++ pkgs.lib.optionals (builtins.currentSystem == "x86_64-linux") [
  auto-cpufreq
  cpuid
  # linuxKernel.packages.linux_latest_libre.turbostat
  pcm
  # zenith-nvidia # 用处不大，和 top 功能重叠
  nvitop # 美观，比 nvidia-smi 好用
  powertop # 分析功耗
  intentrace # strace 类似工具 TODO 居然不支持 aarch64
]
++ [
  # @todo https://github.com/kkharji/sqlite.lua/issues/28
  # 需要设置 libsqlite3.so 的位置
  sqlite
  # wirelesstools
  dos2unix
  # @todo 传统调试工具专门整理为一个包
  # dpdk
  # firecracker
  inetutils
  (python3.withPackages (
    p: with p; [
      ipython
      autopep8
      gcovr
      pygments # 让 gdb-dashboard 支持高亮
      pytest
    ]
  ))
  # ruff # 类似 pyright，据说很快，但是项目太小，看不出什么优势
  # perl
  man-db
  man-pages
  # man-pages-posix
  pre-commit
  lazydocker
  # docker-compose
  openssl
  minicom
  arp-scan
  # nixos-generators # 基于当前系统生成 qcow2
  # packer # 制作 qcow2 镜像
  gum
  asciidoc
  fio
  genact # A nonsense activity generator
  # wtf # The personal information dashboard for your terminal
  progress # 展示 cp dd 之类的进度条
  viddy # A modern watch command.
  # mcfly # better ctrl-r for shell
  pciutils
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
  swtpm # windows 11 启动需要
  # nushell
  # powershell
  # vector
  git-review

  # containerd # @todo 测试下
  # nerdctl
  calcure # 日历，@todo 可以定制化的，有趣

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

  # httpie # http baidu.com
  lcov

  # czkawka # 垃圾文件清理

  # cachix # nixos 的高级玩法，自己架设 binary cache
  clash-meta

  # lsp && formatter
  black # python formatter
  # 似乎不需要在这里安装 rust 的工具
  # rust-analyzer
  # rustfmt
  # clippy

  ccls
  checkmake
  stylua
  lua-language-server
  efm-langserver # 集成 shellcheck
  marksman # nixos 不可以通过 mason 来安装，有动态库的问题
  # typos-lsp
  pyright
]
