{ inputs, ... }:

{
  imports = [
    ./hardware.nix
    ./configuration.nix
    ../../modules/nixos/common
    ../../modules/nixos/desktop/niri.nix
    inputs.noctalia-greeter.nixosModules.default
    inputs.disko.nixosModules.default
    ./disko.nix
  ];
}
