{
  lib,
  stdenv,
  fetchFromGitLab,
  libusb1,
  hidapi,
  pkg-config,
  coreutils,
  mbedtls,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openrgb";
  version = "git-2026-07-16";

  src = fetchFromGitLab {
    owner = "CalcProgrammer1";
    repo = "OpenRGB";
    rev = "1b3480bf8a65d68286f870527b58db64927c4a0f";
    hash = "sha256-mLxWp1+poaSkeZnpof1gkb6lS4dxX+JBwmUa1cfHCQo=";
  };

  nativeBuildInputs = [
    pkg-config
  ]
  ++ (with qt6; [
    qmake
    wrapQtAppsHook
  ]);

  buildInputs = [
    libusb1
    hidapi
    mbedtls
  ]
  ++ (with qt6; [
    qtbase
    qttools
    qtwayland
  ]);

  postPatch = ''
    patchShebangs scripts/build-udev-rules.sh
    substituteInPlace scripts/build-udev-rules.sh \
      --replace-fail '/usr/bin/env' '${coreutils}/bin/env'
  '';

  qmakeFlags = [
    "QT_TOOL.lrelease.binary=${lib.getDev qt6.qttools}/bin/lrelease"
  ];

  meta = {
    description = "Open source RGB lighting control (git master)";
    homepage = "https://gitlab.com/CalcProgrammer1/OpenRGB";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "openrgb";
  };
})
