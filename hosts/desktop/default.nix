{ inputs, ... }:

{
  imports = [
    ./hardware.nix
    ./configuration.nix
    ./gaming.nix
    inputs.disko.nixosModules.default
    ./disko.nix
    ./greeter.nix
    ./storage.nix
    ./plex.nix
    ./jellyfin.nix
    ./appimage.nix
    ./vr.nix
    ./rgb.nix
  ];
}
