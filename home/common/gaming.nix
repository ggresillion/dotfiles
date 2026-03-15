{ pkgs, ... }:
{
  home.packages = with pkgs; [
    umu-launcher
    godot
    r2modman
    faugus-launcher
    gamescope
  ];
}
