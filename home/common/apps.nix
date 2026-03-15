{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    vesktop
    gocryptfs
    kdePackages.gwenview
    nvtopPackages.nvidia
    unzip
    p7zip
    unrar
    deezer-enhanced
    inputs.zen-browser.packages."${stdenv.hostPlatform.system}".default
  ];
}
