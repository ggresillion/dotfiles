{ pkgs, inputs, ... }:

{
  imports = [
    ../../modules/home/shell.nix
    ../../modules/home/dev.nix
    ../../modules/home/desktop.nix
  ];

  programs.home-manager.enable = true;
  home.enableNixpkgsReleaseCheck = false;

  home.username = "guillaume";
  home.homeDirectory = "/home/guillaume";
  home.stateVersion = "26.05";

  # Basic apps — trimmed from ../../modules/home/apps.nix (drop torrenting/gaming-adjacent extras)
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
