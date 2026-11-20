{ pkgs, ... }:

{
  imports = [
    ../../modules/home
    ../../modules/home/desktop
    ../../modules/home/apps.nix
    ../../modules/home/extras.nix
    ../../modules/home/gaming.nix
    ../../modules/home/rgb.nix
  ];

  home.packages = [ pkgs.linux-wallpaperengine ];
}
