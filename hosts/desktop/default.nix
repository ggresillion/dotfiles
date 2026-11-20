{ inputs, ... }:

{
  imports = [
    inputs.disko.nixosModules.default
    ../../modules/nixos/common
    ../../modules/nixos/desktop
    ./hardware.nix
    ./disko.nix
    ./storage.nix
    ./configuration.nix
    ./reboot.nix
    ./rgb.nix
    ./niri-spicy.nix
    ./gaming.nix
    ./vr.nix
    ./appimage.nix
    ./services.nix
  ];
}
