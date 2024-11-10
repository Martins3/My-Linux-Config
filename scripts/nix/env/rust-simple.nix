# https://discourse.nixos.org/t/how-can-i-set-up-my-rust-programming-environment/4501/6
{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  buildInputs = [
    pkgs.cargo
    pkgs.rustc
    pkgs.rustfmt
    pkgs.rustup
    # 测试 gRPC
    pkgs.protobuf

    # Necessary for the openssl-sys crate:
    pkgs.openssl
    pkgs.pkg-config
    pkgs.fuse

    # pkgs.wasm-pack
    # pkgs.wasmer
    # pkgs.wasmtime
  ];

  # See https://discourse.nixos.org/t/rust-src-not-found-and-other-misadventures-of-developing-rust-on-nixos/11570/3?u=samuela.
  RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
}
