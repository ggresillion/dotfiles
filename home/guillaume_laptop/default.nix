{ ... }:

{
  imports = [ ../../modules/home ];

  profiles = {
    desktop.enable = true;
    apps.enable = true;
  };

  home.username = "guillaume";
  home.homeDirectory = "/home/guillaume";
  home.stateVersion = "26.05";
}
