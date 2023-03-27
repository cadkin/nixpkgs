{
  lib,
  stdenv,
  fetchurl,

  qtbase,
  qt5compat,
  qtsvg,
  qttools,
  qtwebengine,
  clazy,
  clang-tools,

  cmake,
  pkg-config,
  wrapQtAppsHook,

  withDocumentation ? true
}:

stdenv.mkDerivation rec {
  pname = "qtcreator";
  version = "9.0.2";
  baseVersion = builtins.concatStringsSep "." (lib.take 2 (builtins.splitVersion version));

  src = fetchurl {
    url = "http://download.qt-project.org/official_releases/${pname}/${baseVersion}/${version}/qt-creator-opensource-src-${version}.tar.xz";
    sha256 = "eca58cc5ca0d397896940542619cf203f5962ee3c882008122272cdb721fa328";
  };

  buildInputs = [
    qtbase
    qt5compat
    qtsvg
    qttools
    qtwebengine
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
  ];

  cmakeFlags = [
    # Workaround for missing CMAKE_INSTALL_DATAROOTDIR in pkgs/development/tools/build-managers/cmake/setup-hook.sh
    "-DCMAKE_INSTALL_DATAROOTDIR=${placeholder "out"}/share"

    # Pass clang paths to CMake which in-turn makes it to compiler defs.
    "-DCLANG_TIDY=${clang-tools}/bin/clang-tidy"
    "-DCLAZY=${clazy}/bin/clazy-standalone"
    "-DCLANGD=${clang-tools}/bin/clangd"

    # Docs.
    (lib.optional withDocumentation "-DWITH_DOCS=ON")
    (lib.optional withDocumentation "-DWITH_ONLINE_DOCS=ON")
  ];

  # Patches:
  #     0001-fix-clang-headers.patch     - Fixes regex and header issues related to clang on Nix.
  #     0002-force-clang-analyzers.patch - Sets the QTC's clang tools to the ones in the Nix store. Can be overridden by overriding
  #                                        this derivation's inputs.
  patches = [
    ./0001-fix-clang-headers.patch
    ./0002-force-clang-analyzers.patch
  ];

  postInstall = ''
    substituteInPlace $out/share/applications/org.qt-project.qtcreator.desktop --replace "Exec=qtcreator" "Exec=$out/bin/qtcreator"
  '';

  meta = {
    description = "Cross-platform IDE tailored to the needs of Qt developers";
    longDescription = ''
      Qt Creator is a cross-platform IDE (integrated development environment)
      tailored to the needs of Qt developers. It includes features such as an
      advanced code editor, a visual debugger and a GUI designer.
    '';
    homepage = "https://wiki.qt.io/Category:Tools::QtCreator";
    license = "LGPL";
    maintainers = [ lib.maintainers.cadkin lib.maintainers.akaWolf ];
    platforms = [ "i686-linux" "x86_64-linux" "aarch64-linux" "armv7l-linux" ];
  };
}
