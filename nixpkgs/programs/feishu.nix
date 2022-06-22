{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  wrapGAppsHook,
  fakeroot,

  alsa-lib,
  atk,
  at-spi2-atk,
  at-spi2-core,
  avahi,
  bzip2,
  cairo,
  cups,
  dbus,
  expat,
  fontconfig,
  freetype,
  fribidi,
  gdk-pixbuf,
  glib,
  glibc,
  gmp,
  gnutls,
  graphite2,
  gtk3,
  harfbuzz,
  icu,
  json-glib,
  libcap,
  libdatrie,
  libdrm,
  libepoxy,
  libffi,
  libgcrypt,
  libglvnd,
  libgpg-error,
  libjpeg_turbo,
  libpng_apng,
  libselinux,
  libtasn1,
  libthai,
  libunistring,
  xorg,
  libxkbcommon,
  libxml2,
  lz4,
  mesa,
  nettle,
  nspr,
  nss,
  p11-kit,
  pango,
  pcre,
  pixman,
  sqlite,
  systemd,
  tracker,
  util-linux,
  wayland,
  xz,
  zlib,
  zstd,
}:
let
  version = "5.4.13";
  rpath = lib.makeLibraryPath [
    alsa-lib
    atk
    at-spi2-atk
    at-spi2-core
    avahi
    bzip2
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    fribidi
    gdk-pixbuf
    glib
    glibc
    gmp
    gnutls
    graphite2
    gtk3
    harfbuzz
    icu
    json-glib
    libcap
    libdatrie
    libdrm
    libepoxy
    libffi
    libgcrypt
    libglvnd
    libgpg-error
    libjpeg_turbo
    libpng_apng
    libselinux
    libtasn1
    libthai
    libunistring
    xorg.libX11
    xorg.libXau
    xorg.libxcb
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXdmcp
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXinerama
    xorg.libXrandr
    xorg.libXrender
    xorg.libxshmfence
    libxkbcommon
    libxml2
    lz4
    mesa
    nettle
    nspr
    nss
    p11-kit
    pango
    pcre
    pixman
    sqlite
    systemd
    tracker
    util-linux
    wayland
    xz
    zlib
    zstd
  ] + ":${stdenv.cc.cc.lib}/lib64";
  src =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      fetchurl {
        urls = [
          "https://sf3-cn.feishucdn.com/obj/ee-appcenter/e734d9e40e6a/Feishu-linux_x64-5.4.13.deb"
        ];
        sha256 = "11jriak4cdg3zy39y7xpbn6hk32gq96ryrpqvd03cwrzw4hdrp96";
      }
    else
      throw "Feishu for Linux is not supported on ${stdenv.hostPlatform.system}";
in
stdenv.mkDerivation {
  pname = "feishu";
  inherit version;

  system = "x86_64-linux";

  inherit src;

  nativeBuildInputs = [
    wrapGAppsHook
    glib # For setup hook populating GSETTINGS_SCHEMA_PATH
  ];

  buildInputs = [ dpkg ];

  dontUnpack = true;
  installPhase = ''
    mkdir -p $out
    ${fakeroot}/bin/fakeroot dpkg-deb -x $src $out
    cp -av $out/usr/share/ $out

    mkdir -p $out/bin
    ln -s "$out/opt/bytedance/feishu/bytedance-feishu" "$out/bin/"
    ln -s "$out/opt/bytedance/feishu/bytedance-feishu" "$out/bin/bytedance-feishu-dev"

    # icons
    for icon in $out/opt/bytedance/feishu/*.png
    do
      # product_logo_128.png
      width=''${icon##*_}
      width=''${width%.png}
      icon_path="$out/share/icons/hicolor/''${width}x''${width}/apps"
      mkdir -p ''${icon_path}
      echo "symlink ''${icon} to ''${icon_path}/bytedance-feishu.png"
      ln -s "''${icon}" "''${icon_path}/bytedance-feishu.png"
    done
  '';

  postFixup = ''
    for file in $(find $out -type f \( -perm /0111 -o -name \*.so\* \) ); do
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$file" || true
      patchelf --set-rpath ${rpath}:$out/opt/bytedance/feishu $file || true
    done

    # Fix the desktop link
    substituteInPlace $out/share/menu/bytedance-feishu.menu \
      --replace /opt $out/opt
    substituteInPlace $out/share/applications/bytedance-feishu.desktop \
      --replace /usr/bin $out/bin
  '';

  meta = with lib; {
    description = "Feishu for Linux";
    homepage = "https://www.feishu.cn/";
    license = licenses.unfree;
    maintainers = with maintainers; [ xieby1 ];
    platforms = [ "x86_64-linux" ];
  };
}
