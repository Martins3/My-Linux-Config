# nix-env -f ./linux.nix -i
# shell-nix --cmd zsh
let
pkgs = import <nixpkgs> {
};
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
# TMP_TODO what does this mean ?
/* warning: not including '/nix/store/ins8q19xkjh21fhlzrxv0dwhd4wq936s-nix-shell' in the user environment because it's not a directory */

