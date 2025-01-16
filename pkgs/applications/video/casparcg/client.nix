{
  lib, stdenv, fetchFromGitHub,
  cmake, pkg-config, wrapQtAppsHook,

  # Package depends.
  boost,
  qtbase,
  qtwebsockets,
  qt5compat,
  libvlc,

  # Link-time depends.
  icu,
  zlib
}:

stdenv.mkDerivation rec {
  pname = "casparcg-server";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "CasparCG";
    repo = "client";
    rev = "v${version}";
    hash = "sha256-Hf+L3PZl7W9kEUZ4a9HDTpwoD4i8oLrxFfMhc2f5nqs=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    boost
    qtbase
    qtwebsockets
    qt5compat
    libvlc
  ];

  cmakeFlags = [
    "-S ${src}/src"
  ];

  meta = {
    description = "Professional live video graphics - client";
    longDescription = ''
      Client software primarily used with the CasparCG Server software for
      audio and video playout, to control graphics and recording, but it can
      also be used for other tasks within television broadcast.
    '';
    homepage = "https://github.com/CasparCG/client";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.cadkin ];
    platforms = lib.platforms.linux;
  };
}
