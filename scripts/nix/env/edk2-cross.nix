let
  pkgs_arm_cross = import <nixpkgs> {
    crossSystem = "aarch64-linux";
  };
  pkgs = import <nixpkgs> {};
in
pkgs.mkShell {
  buildInputs = with pkgs_arm_cross; [
    # packages for cross compiling, run on local system (x86_64)
    stdenv.cc
    binutils
    # here stdenv.cc is the same with buildPackages.gcc
  ] ++ (with pkgs; [
    # packages run on local system (x86_64)
    libuuid
  ]);
}

# ➜ source edksetup.sh
# ➜ export GCC5_AARCH64_PREFIX=aarch64-unknown-linux-gnu-  # nixos 中
