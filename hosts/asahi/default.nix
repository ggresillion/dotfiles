{ inputs, ... }:

{
  imports = [
    ./hardware.nix
    ./configuration.nix
    ../../modules/nixos/common
    ../../modules/nixos/desktop/niri.nix
    inputs.apple-silicon.nixosModules.apple-silicon-support
  ];
}
