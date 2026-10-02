{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation {
  pname = "deezer-tui";
  version = "1.18.0";

  src = fetchurl {
    url = "https://github.com/Tatayoyoh/deezer-tui/releases/download/v1.18.0/deezer-tui-linux-x86_64";
    hash = "sha256-Pdq7L5RAN0CvRuuUG/Fa8+M7xnbn6gINjyH8y54g804=";
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
