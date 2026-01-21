{ inputs, ... }:

{
  imports = [
    ./hardware.nix
    ./configuration.nix
    ./gaming.nix

    inputs.disko.nixosModules.default
    ./disko.nix
  ];
}
