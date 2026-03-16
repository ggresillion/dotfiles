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
  ];

  programs.home-manager.enable = true;
}
