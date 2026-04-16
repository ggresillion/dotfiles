{ pkgs, ... }:

{
  imports = [
    ../common
  ];

  home.username = "guillaume_thetreep";
  home.homeDirectory = "/home/guillaume_thetreep";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    slack
    _1password-gui
  ];
}
