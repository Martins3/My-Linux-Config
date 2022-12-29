{ pkgs ? import <nixpkgs> { } }:

pkgs.stdenv.mkDerivation {
  name = "kernel";
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

    # selftests
    alsa-lib
    libcap
    libmnl
    libcap_ng
    liburing

    # rust language
    # @todo 还没有太搞清楚如何索引 Rust 项目
    pkgs.cargo
    pkgs.rustc
    pkgs.rustfmt

    # Necessary for the openssl-sys crate:
    pkgs.openssl
    pkgs.pkg-config

    pkgs.graphviz

    (python3.withPackages (p: with p; [
      sphinx
      # 修改 Documentation/conf.py 中 html_theme = 'sphinx_rtd_theme'
      sphinx-rtd-theme
    ]))
    libopcodes
    numactl
    /* numa_num_possible_cpus */
    /* libperl */
    libunwind
    lzma
    zstd
    perl
  ];

  # See https://discourse.nixos.org/t/rust-src-not-found-and-other-misadventures-of-developing-rust-on-nixos/11570/3?u=samuela.
  RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
}
