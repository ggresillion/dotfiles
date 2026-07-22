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
    # The 60-openrgb.rules udev_rules install target in OpenRGB.pro is only
    # wired up under CONFIG(release, debug|release); force it explicitly so
    # `make install` reliably produces $out/lib/udev/rules.d/60-openrgb.rules.
    "CONFIG+=release"
  ];

  # Fail the build loudly rather than silently shipping a package with no
  # udev rules, which manifests at runtime as "Connection attempt failed" /
  # needing root to run OpenRGB - see build-udev-rules.sh + OpenRGB.pro.
  postInstall = ''
    if [ ! -f "$out/lib/udev/rules.d/60-openrgb.rules" ]; then
      echo "ERROR: 60-openrgb.rules was not installed to $out/lib/udev/rules.d/" >&2
      echo "OpenRGB will require root and services.udev.packages will do nothing." >&2
      exit 1
    fi
  '';

  meta = {
    description = "Open source RGB lighting control (git master)";
    homepage = "https://gitlab.com/CalcProgrammer1/OpenRGB";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "openrgb";
  };
})
