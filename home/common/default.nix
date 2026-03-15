{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:

let
  dotfiles = "${config.home.homeDirectory}/dotfiles/home/common/config";
  args = {
    config = config;
    pkgs = pkgs;
    lib = lib;
    inputs = inputs;
    dotfiles = dotfiles;
  };
in
{
  imports = [
    (import ./dev.nix args)
    (import ./shell.nix args)
    (import ./desktop.nix args)
    (import ./gaming.nix args)
    (import ./apps.nix args)
  ];

  programs.home-manager.enable = true;
}
