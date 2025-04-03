{
  lib,
  stdenv,
  linkFarm,
  rustPlatform,
  clangStdenv,
  fetchFromGitHub,
  runCommand,

  cmake,
  pkg-config,
  cargo,
  corrosion,
  rustc,
  ninja,
  makeWrapper,

  libGL,
  xorg,
  libxkbcommon,
  wayland,
  rust-cbindgen,
}:

clangStdenv.mkDerivation rec {
  pname = "slint-cpp";
  version = "1.11";

  src = fetchFromGitHub {
    owner = "slint-ui";
    repo  = "slint";
    rev   = "23aa4ed8c62c23f8ae618dca51597f4e47d4cf74";
    hash  = "sha256-JBt8S4sqJMUsAvMA1XSPFJ5D/XAvOiSmXCuovwa22Fc=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config

    cargo
    rustc

    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    libGL
    xorg.libxcb
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
    xorg.libxcb
    libxkbcommon
    wayland
    corrosion
  ];

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
  };

  auditable = false;
  doCheck = false;

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';
}
