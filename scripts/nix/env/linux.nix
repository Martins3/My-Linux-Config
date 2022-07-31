# nix-env -f ./linux.nix -i
# shell-nix --cmd zsh
let
pkgs = import <nixpkgs> {};
in

pkgs.mkShell rec {
  nativeBuildInputs = with pkgs.buildPackages; [
    bison
    flex
    lzop
    pkgconfig
    ncurses
    openssl
    elfutils
    bc
   ];
  buildInputs = with pkgs; [ zlib ];
}
