{
  lib, stdenv, fetchFromGitHub,
  cmake, pkg-config,

  # Package depends.
  boost,
  ffmpeg,
  libGLU, libGL,
  freeimage,
  glew,
  tbb,
  openal,
  sfml,
  libX11,

  # Link-time depends.
  icu,
  zlib
}:

stdenv.mkDerivation rec {
  pname = "casparcg-server";
  version = "2.4.2";

  src = fetchFromGitHub {
    owner = "CasparCG";
    repo = "server";
    rev = "v${version}-stable";
    hash = "sha256-AnI7MmCwG2El/+K2RDYCaF690LnjNPlT5RahT7CKWNo=";
  };

  sourceRoot = "${src.name}/src";

  patches = [
    ./0001-server-install.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    boost
    ffmpeg
    libGLU
    libGL
    freeimage
    glew
    tbb
    openal
    sfml
    libX11
    icu
    zlib
  ];

  cmakeFlags = [
    "-DUSE_SYSTEM_FFMPEG=ON"
    "-DUSE_STATIC_BOOST=OFF"
    "-DENABLE_HTML=OFF"
  ];

  meta = {
    description = "Professional live video graphics - server";
    longDescription = ''
      CasparCG Server is a Windows and Linux software used to play out
      professional graphics, audio and video to multiple outputs.
    '';
    homepage = "https://github.com/CasparCG/server";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.cadkin ];
    platforms = lib.platforms.linux;
  };
}
