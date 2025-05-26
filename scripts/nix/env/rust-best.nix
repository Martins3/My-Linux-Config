{
  pkgs ? import <nixpkgs> { },
}:
let
  overrides = (builtins.fromTOML (builtins.readFile ./rust-toolchain.toml));
in
pkgs.callPackage (
  {
    stdenv,
    mkShell,
    rustup,
    rustPlatform,

  }:
  mkShell {
    strictDeps = true;
    nativeBuildInputs = with pkgs; [
      rustup
      rustPlatform.bindgenHook
      # firecracker 中 aws-lc
      (python3.withPackages (
        p: with p; [
          seccomp
        ]
      ))
    ];

    # libraries here
    buildInputs = with pkgs; [
      libseccomp
      rust-analyzer
    ];
    RUSTC_VERSION = overrides.toolchain.channel;
    # https://github.com/rust-lang/rust-bindgen#environment-variables
    shellHook = ''
      export PATH="''${CARGO_HOME:-~/.cargo}/bin":"$PATH"
      export PATH="''${RUSTUP_HOME:-~/.rustup}/toolchains/$RUSTC_VERSION-${stdenv.hostPlatform.rust.rustcTarget}/bin":"$PATH"
    '';
  }
) { }
# firecracker : 直接 cargo build --features "gdb" 就可以了
# 如果 rust-analyzer 立刻退出，那么试试，基本都是可以解决
# rustup component add rust-analyzer
# 虽然不知道为什么
