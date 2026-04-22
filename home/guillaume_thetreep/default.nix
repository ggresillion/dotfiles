{ pkgs, ... }:

{
  imports = [
    ../common
  ];

  home.username = "guillaume_thetreep";
  home.homeDirectory = "/home/guillaume_thetreep";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    slack
    _1password-gui
  ];
}
