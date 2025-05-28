# https://discourse.nixos.org/t/how-can-i-set-up-my-rust-programming-environment/4501/6
with import <nixpkgs> { };
pkgs.llvmPackages.stdenv.mkDerivation {
  hardeningDisable = [ "all" ];
  name = "simple-rust";
  buildInputs = with pkgs; [
    cargo
    rustc
    rustfmt
    rustup

    # Necessary for the openssl-sys crate
    openssl
    pkg-config

    rust-analyzer
    # wasm-pack
    # wasmer
    # wasmtime
    libclang
    cmake
    glibc
    glibc.dev


    fuse

    # IronRDP
    alsa-lib
    libopus

    # alacritty
    fontconfig

    # 测试 gRPC
    protobuf
  ];

  # See https://discourse.nixos.org/t/rust-src-not-found-and-other-misadventures-of-developing-rust-on-nixos/11570/3?u=samuela.
  LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";
  RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
  BINDGEN_EXTRA_CLANG_ARGS = "-I${pkgs.glibc.dev}/include -I${pkgs.linuxHeaders}/include";
}
