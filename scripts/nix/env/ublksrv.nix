let
  pkgs = import <nixpkgs> { };
in
pkgs.mkShell rec {
  buildInputs = with pkgs; [
    autoconf
    automake
    libtool
		pkg-config

    liburing
  ];
}
# autoreconf -i
# ./configure
# make -j
