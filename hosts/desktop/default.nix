{ inputs, ... }:

{
  imports = [
    ./hardware.nix
    ./configuration.nix
    ../../modules/nixos/common
    ../../modules/nixos/desktop/niri.nix
    ./gaming.nix
    inputs.disko.nixosModules.default
    ./disko.nix
    ./storage.nix
    ./jellyfin.nix
    ./appimage.nix
    ./vr.nix
    ./llm.nix
    ./network.nix
  ];
}
