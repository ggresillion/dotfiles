{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nixwrap.url = "github:rti/nixwrap";
  };

  outputs = { nixpkgs, nixpkgs-stable, home-manager, ... }@inputs: {
    nixosConfigurations.guillaume-desktop = let
      system = "x86_64-linux";

      pkgsStable = import nixpkgs-stable { inherit system; };
    in nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs; };

      modules = [
        ./hosts/desktop
        home-manager.nixosModules.home-manager
        # override has unstable version was not working
        { nixpkgs.overlays = [ (final: prev: { khal = pkgsStable.khal; }) ]; }
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.guillaume = import ./home/guillaume/home.nix;
          home-manager.extraSpecialArgs = { inherit inputs; };
        }
      ];
    };
  };
}
