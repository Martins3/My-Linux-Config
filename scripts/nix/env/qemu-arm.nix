let
  pkgs_arm_cross = import <nixpkgs> {
    # get this config on my android
    #   nix repl
    #   builtins.currentSystem
    crossSystem = "aarch64-linux";
  };
  pkgs = import <nixpkgs> {};
in
pkgs.mkShell {
  buildInputs = with pkgs_arm_cross; [
    # packages for cross compiling, run on local system (x86_64)
    stdenv.cc
    pkgconfig
    # here stdenv.cc is the same with buildPackages.gcc
  ] ++ (with pkgs; [
    # packages run on local system (x86_64)
    ninja
    glib
    pixman
    xorg.libX11.dev
    rdma-core
    liburing
  ]);
}

# 编译的方法:
# ../configure --target-list=aarch64-softmmu --enable-kvm --cross-prefix=aarch64-unknown-linux-gnu-
