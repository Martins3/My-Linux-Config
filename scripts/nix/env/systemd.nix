# https://github.com/systemd/systemd
with import <nixpkgs> { };
clangStdenv.mkDerivation {
  name = "systemd";
  buildInputs = [
    gperf
    libxcrypt
    libcap
    glibc
    # 奇怪，必须有这个，不然有这个错误
    # meson.build:571:0: ERROR: Assert failed: long_max > 100000
  ];

  nativeBuildInputs = with pkgs; [
    meson
    ninja
    pkg-config
  ];
}

# meson setup build/
# ninja -C build/
# TODO 似乎这个构建了很少的部分
