let
pkgs = import <nixpkgs> { };
in
pkgs.mkShell rec {
  buildInputs = with pkgs; [
  bison
  ];
}

# git clone https://github.com/bminor/glibc
# mkdir -p build && cd build
# ../configure --prefix "$(pwd)/install"
