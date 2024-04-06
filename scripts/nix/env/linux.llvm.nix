# 1. 之前的写法
# { pkgs ? import <nixpkgs> { },
#   unstable ? import <nixos-unstable> { }
# }:
with import <nixpkgs> {};

# TODO 很奇怪，LLVM 无法正常构建内核，需要将版本下移到 6.1 左右才可以

# 2. 之前的写法
# pkgs.stdenv.mkDerivation {
pkgs.llvmPackages.stdenv.mkDerivation {

# llvmPackages 是可以指定版本的
# pkgs.llvmPackages_14.stdenv.mkDerivation {
  name = "yyds";
  buildInputs = with pkgs; [

    getopt
    flex
    bison
    gcc
    gnumake
    bc
    rpm
    dpkg
    pahole # bpf
    pkg-config
    binutils

    elfutils
    ncurses
    openssl
    zlib
    lld
    llvm
    # selftests
    alsa-lib
    libcap
    libmnl
    libcap_ng
    liburing


	# unstable.rustfmt
	# unstable.rustc
	# unstable.cargo
	# unstable.rust-bindgen

    # Necessary for the openssl-sys crate:
    pkgs.openssl
    pkgs.pkg-config

    pkgs.graphviz

    (python3.withPackages (p: with p; [
      sphinx
      # 修改 Documentation/conf.py 中 html_theme = 'sphinx_rtd_theme'
      sphinx-rtd-theme
      pyyaml
    ]))
    libopcodes
    numactl
    /* numa_num_possible_cpus */
    /* libperl */
    libunwind
    lzma
    zstd
    perl
    # @todo 不知道为什么现在 perf 缺少这个库
    libtraceevent
  ];

  # See https://discourse.nixos.org/t/rust-src-not-found-and-other-misadventures-of-developing-rust-on-nixos/11570/3?u=samuela.
  RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
}
