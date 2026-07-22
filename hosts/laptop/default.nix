{ inputs, ... }:

{
  imports = [
    ./hardware.nix
    ./configuration.nix
    inputs.disko.nixosModules.default
    ./disko.nix
    ../desktop/greeter.nix
  ];
}
