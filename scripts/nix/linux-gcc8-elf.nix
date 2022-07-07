let
    pkgs = import (builtins.fetchTarball {
        url =q "https://github.com/NixOS/nixpkgs/archive/66c745e30d26ee30de4a6fa4dfc7862b48ee2697.tar.gz";
    }) {};

    myPkg = pkgs.elfutils;
in

 with import <nixpkgs> {}; {
  qpidEnv = stdenvNoCC.mkDerivation {
    name = "my-gcc8-environment";
    buildInputs = [
        gcc8
        bison
        flex
        lzop
        pkgconfig
        ncurses
        openssl
        # https://groups.google.com/g/linux.gentoo.user/c/IuL41BqSpNE?pli=1
        # https://www.spinics.net/lists/kernel/msg3797871.html
        /* "elfutils-0.185" */
        bc
        myPkg
    ];
  };
}
