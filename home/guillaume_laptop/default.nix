{ pkgs, inputs, ... }:

{
  imports = [
    ../common/shell.nix
    ../common/dev.nix
    ../common/desktop.nix
  ];

  programs.home-manager.enable = true;
  home.enableNixpkgsReleaseCheck = false;

  home.username = "guillaume";
  home.homeDirectory = "/home/guillaume";
  home.stateVersion = "26.05";

  # Basic apps — trimmed from ../common/apps.nix (drop torrenting/gaming-adjacent extras)
  home.packages = with pkgs; [
    inputs.zen-browser.packages."${stdenv.hostPlatform.system}".default
    yazi
    btop
    fastfetch
    unzip
    p7zip
    unrar
    vlc
  ];
}
