{
  ...
}:
{
  imports = [
    ./dev.nix
    ./shell.nix
    ./desktop.nix
    ./gaming.nix
    ./apps.nix
    ./rgb.nix
    ./keyboard-compose.nix
  ];

  programs.home-manager.enable = true;
  home.enableNixpkgsReleaseCheck = false;
}
