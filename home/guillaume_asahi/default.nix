{ config, lib, ... }:

let
  flake = "${config.home.homeDirectory}/nixos#(hostname)";
in
{
  imports = [ ../../modules/home ];

  profiles.desktop.enable = true;

  services.linux-wallpaperengine.enable = lib.mkForce false;

  # --impure lets nixos-apple-silicon read the non-redistributable Wi-Fi/webcam
  # firmware from /boot/vendorfw, which can't live in this public repo.
  home.shellAliases = {
    nrs = lib.mkForce "sudo nixos-rebuild switch --impure --flake ${flake}";
    nrt = lib.mkForce "sudo nixos-rebuild test --impure --flake ${flake}";
  };

  home.username = "guillaume";
  home.homeDirectory = "/home/guillaume";
  home.stateVersion = "26.05";
}
