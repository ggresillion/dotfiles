{ config, pkgs, ... }:

{
  programs.zellij = {
    enable = true;
  };

  xdg.configFile = {
    "zellij/config.kdl".source = ./config.kdl;
    "zellij/layouts/default.kdl".source = ./layouts/default.kdl;
  };
}
