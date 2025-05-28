with import <nixpkgs> { };
pkgs.llvmPackages.stdenv.mkDerivation {
  # hardeningDisable = [ "all" ];
  name = "xen";
  buildInputs = with pkgs; [

    libuuid
    glib
    pixman
    yajl
    fig2dev
    pandoc
    ncurses
    pkg-config

    flex
    bison
    gcc
    gnumake

    # ./configure
    # make world
    # make install
    # 如果在虚拟机中使用，那么需要添加这个
    # qemu
    xen
    python3.pkgs.setuptools
    python3.pkgs.distutils
  ];
}
