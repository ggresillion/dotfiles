{ inputs, ... }:

{
  imports = [
    ./hardware.nix
    ./configuration.nix
    # M3 GPU via the Aurora stack: enable once the base install boots.
    # ./aurora-gpu.nix
    ../../modules/nixos/common
    ../../modules/nixos/desktop/niri.nix
    inputs.apple-silicon.nixosModules.apple-silicon-support
  ];
}
