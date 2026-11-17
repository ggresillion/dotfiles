{ lib, ... }:

{
  imports = [ ../../modules/home ];

  profiles = {
    desktop.enable = true;
    apps.enable = true;
  };

  services.linux-wallpaperengine.enable = lib.mkForce false;

  home.username = "guillaume";
  home.homeDirectory = "/home/guillaume";
  home.stateVersion = "26.05";
}
