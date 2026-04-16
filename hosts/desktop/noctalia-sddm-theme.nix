{ stdenv, fetchFromGitHub }:
stdenv.mkDerivation {
  name = "noctalia-sddm-theme";
  src = fetchFromGitHub {
    owner = "mahaveergurjar";
    repo = "sddm";
    rev = "noctalia";
    sha256 = "sha256-q/aw4PLSHhS2jKjRl8F1JIBZn1aBV/QBEDgZ+2Oyo2A=";
  };
  installPhase = ''
    mkdir -p $out/share/sddm/themes/noctalia
    cp -r * $out/share/sddm/themes/noctalia
  '';
}
