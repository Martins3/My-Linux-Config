let
  pkgs = import <nixpkgs> { };
in
pkgs.mkShell rec {
  nativeBuildInputs = with pkgs.buildPackages; [
    pkg-config
    po4a
    zlib
    libxcrypt
    pam
    libcap_ng
    ncurses
    systemd
    bison
    gettext
    ninja
  ];
}
# meson build && cd build && ninja -j32
# mv compile_commands.json ..
