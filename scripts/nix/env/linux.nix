with import <nixpkgs> {};
pkgs.llvmPackages.stdenv.mkDerivation {
   hardeningDisable = [ "all" ];
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
    # selftests 需要依赖的哭
    alsa-lib
    libcap
    libmnl
    libcap_ng
    liburing
    libaio

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
  # RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
}
