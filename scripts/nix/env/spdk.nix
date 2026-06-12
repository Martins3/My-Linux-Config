{
  pkgs ? import <nixpkgs> { },
}:

pkgs.mkShell {
  packages = with pkgs; [
    autoconf
    automake
    cunit
    fuse3
    gcc
    help2man
    libaio
    libtool
    liburing
    meson
    nasm
    ncurses
    ninja
    numactl
    openssl
    perl
    pkg-config
    python3
    python3Packages.jinja2
    python3Packages.pyelftools
    python3Packages.tabulate
    util-linux
  ];

  shellHook = ''
        export AS=

        cat <<'EOF'
    SPDK nix shell ready.

    Use:
      ./configure --without-fio --target-arch=x86-64-v2 --with-ublk
      make -j$(nproc)
    EOF
  '';
}
