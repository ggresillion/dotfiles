{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation {
  pname = "deezer-tui";
  version = "unstable";

  src = fetchurl {
    url = "https://github.com/Tatayoyoh/deezer-tui/releases/latest/download/deezer-tui-linux-x86_64";
    hash = "sha256-eEbZAcApI3Ea1vmiDVcHIHLcQnBvvyaKshBdDtYIO1U=";
  };

  dontUnpack = true;

  installPhase = ''
    install -Dm755 $src $out/bin/deezer-tui
  '';

  meta = with lib; {
    description = "Deezer terminal UI client";
    homepage = "https://github.com/Tatayoyoh/deezer-tui";
    license = licenses.mit;
    mainProgram = "deezer-tui";
    platforms = platforms.linux;
  };
}
