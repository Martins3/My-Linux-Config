let
  pkgs = import <nixpkgs> { };
in
pkgs.mkShell rec {
  nativeBuildInputs = with pkgs.buildPackages; [
    pkg-config
    autoconf
    gettext
    autoconf-archive
    autoconf
    automake
    libtool
    bison
    flex
  ];
  buildInputs = with pkgs; [ zlib ];
}

# ./autogen.sh
# ./configure
# make sudo make install
