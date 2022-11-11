let
  pkgs_arm_cross = import <nixpkgs> {
    # get this config on my android
    #   nix repl
    #   builtins.currentSystem
    crossSystem = "aarch64-linux";
  };
  pkgs = import <nixpkgs> { };
in
pkgs.mkShell {
  buildInputs = with pkgs_arm_cross; [
    # packages for cross compiling, run on local system (x86_64)
    stdenv.cc
    # here stdenv.cc is the same with buildPackages.gcc
  ] ++ (with pkgs; [
    # packages run on local system (x86_64)
    pkgconfig
    bison
    flex
    lzop
    ncurses
    openssl
    elfutils
    bc
  ]);
}
