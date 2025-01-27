# https://discourse.nixos.org/t/how-can-i-set-up-my-rust-programming-environment/4501/6
with import <nixpkgs> { };
pkgs.llvmPackages.stdenv.mkDerivation {
  hardeningDisable = [ "all" ];
  name = "yyds";
  buildInputs = with pkgs; [
    cargo
    rustc
    rustfmt
    rustup
    # 测试 gRPC
    protobuf

    # Necessary for the openssl-sys crate:
    openssl
    pkg-config
    fuse

    rust-analyzer
    # wasm-pack
    # wasmer
    # wasmtime
    libclang
    libseccomp
    linuxHeaders
    cmake
    glibc
    glibc.dev
    # firecracker 中 aws-lc 需要，搞了半天才知道
    (python3.withPackages (
      p: with p; [
        seccomp
      ]
    ))

    # IronRDP
    alsa-lib
    libopus

    # alacritty
    fontconfig
  ];

  # See https://discourse.nixos.org/t/rust-src-not-found-and-other-misadventures-of-developing-rust-on-nixos/11570/3?u=samuela.
  LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";
  RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
  BINDGEN_EXTRA_CLANG_ARGS = "-I${pkgs.glibc.dev}/include -I${pkgs.linuxHeaders}/include";
}
