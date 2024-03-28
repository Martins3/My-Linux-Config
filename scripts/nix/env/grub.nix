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

# ./boottrap.sh
# ./configure --prefix=$(pwd)/install --with-platform=efi
