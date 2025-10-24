# https://github.com/systemd/systemd
with import <nixpkgs> { };
clangStdenv.mkDerivation {
  name = "systemd";
  buildInputs = [
    gperf
    libxcrypt
    libcap
  ];

  nativeBuildInputs = with pkgs; [
    meson
    ninja
    pkg-config
  ];
}
# meson setup build/ && ninja -C build/
