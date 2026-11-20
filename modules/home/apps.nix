{ pkgs, inputs, ... }:

# Everyday GUI and CLI apps.
{
  home.packages = with pkgs; [
    inputs.zen-browser.packages.${stdenv.hostPlatform.system}.default
    yazi
    btop
    fastfetch
    unzip
    p7zip
    unrar
    vlc
    claude-code
    rtk
  ];
}
