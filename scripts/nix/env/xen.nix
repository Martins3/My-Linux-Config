with import <nixpkgs> { };
pkgs.llvmPackages.stdenv.mkDerivation {
  hardeningDisable = [ "all" ];
  name = "yyds";
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
  ];
}
