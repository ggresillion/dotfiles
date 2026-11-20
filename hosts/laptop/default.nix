{ inputs, ... }:

{
  imports = [
    inputs.disko.nixosModules.default
    ../../modules/nixos/common
    ../../modules/nixos/desktop
    ./hardware.nix
    ./disko.nix
    ./configuration.nix
  ];
}
