with import <nixpkgs> {};
pkgs.llvmPackages.stdenv.mkDerivation {
  name = "yyds wayland";
  buildInputs = with pkgs; [
    binutils
    cmake
    libdrm
    libinput
    libseat
    libxkbcommon
    mesa
    meson
    ninja
    pixman
    libGL # 提供 EGL/egl.h
    pkg-config
    wayland
    wayland-protocols
    xorg.xcbproto
    xorg.xcbutil
    xwayland
    egl-wayland
  ];
}
# 和 vn/code/module/c/wayland 配合使用
