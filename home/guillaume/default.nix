{ ... }:

{
  imports = [ ../../modules/home ];

  profiles = {
    desktop.enable = true;
    apps.enable = true;
    apps.extras.enable = true;
    gaming.enable = true;
    rgb.enable = true;
  };

  home.username = "guillaume";
  home.homeDirectory = "/home/guillaume";
  home.stateVersion = "26.05";
}
