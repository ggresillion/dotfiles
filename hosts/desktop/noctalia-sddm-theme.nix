{ stdenv, fetchFromGitHub }:
stdenv.mkDerivation {
  pname = "noctalia-sddm-theme";
  version = "0.0.1";
  src = fetchFromGitHub {
    owner = "mda-dev";
    repo = "noctalia-sddm-theme";
    rev = "main";
    sha256 = "sha256-K1Bj+TZgskUHHbfhmZkuLz+2BWMyFXOpP/aR2GwhzKA=";
  };
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/share/sddm/themes/noctalia
    cp -r * $out/share/sddm/themes/noctalia
  '';
}
