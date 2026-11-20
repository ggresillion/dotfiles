{ pkgs, ... }:

# Base home config, on every host (mac included): shell, editor and dev tools.
# Hosts add the other modules here from their home.nix:
#   ./desktop  niri + dux shell (Linux)
#   ./apps.nix, ./extras.nix, ./gaming.nix, ./rgb.nix
{
  imports = [
    ./shell.nix
    ./dev.nix
  ];

  programs.home-manager.enable = true;
  home.enableNixpkgsReleaseCheck = false;

  home.username = "guillaume";
  home.homeDirectory =
    if pkgs.stdenv.hostPlatform.isDarwin then "/Users/guillaume" else "/home/guillaume";
  home.stateVersion = "26.05";
}
