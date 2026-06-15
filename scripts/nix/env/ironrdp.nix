{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  name = "ironrdp-dev";

  buildInputs = with pkgs; [
    # Rust toolchain (使用项目 rust-toolchain.toml 指定的版本)
    rustup

    # 系统库依赖
    alsa-lib
    alsa-lib.dev
    openssl
    openssl.dev
    pkg-config

    # 构建工具
    cmake
    gnumake
    gcc
    perl # 某些 crate 构建脚本需要

    # 可选：开发工具
    git
  ];

  shellHook = ''
    echo "IronRDP 开发环境已加载"
    echo ""
    echo "可用命令:"
    echo "  cargo build --workspace     # 构建完整项目"
    echo "  cargo build -p ironrdp-server # 仅构建服务器"
    echo "  cargo xtask check tests -v   # 运行测试"
    echo ""
    echo "Rust 版本: $(rustc --version 2>/dev/null || echo '请先运行 rustup show')"
  '';

  # 设置环境变量，确保 cargo 能找到系统库
  PKG_CONFIG_PATH = with pkgs; lib.makeSearchPath "lib/pkgconfig" [
    alsa-lib.dev
    openssl.dev
  ];

  ALSA_LIB_DIR = "${pkgs.alsa-lib}/lib";
  OPENSSL_DIR = "${pkgs.openssl.dev}";
  OPENSSL_LIB_DIR = "${pkgs.openssl.out}/lib";
}
