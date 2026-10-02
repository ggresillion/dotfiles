{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixwrap.url = "github:rti/nixwrap";
    millennium = {
      url = "github:SteamClientHomebrew/Millennium?dir=packages/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
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
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin-limine = {
      url = "github:catppuccin/limine";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-darwin,
      nix-darwin,
      home-manager,
      nix-index-database,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ self.overlays.default ];
      };

      homeManagerConfig = home: {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.guillaume = import home;
        home-manager.extraSpecialArgs = { inherit inputs; };
      };

      mkHost =
        { host, home }:
        nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            host
            nix-index-database.nixosModules.default
            home-manager.nixosModules.home-manager
            { nixpkgs.overlays = [ self.overlays.default ]; }
            (homeManagerConfig home)
          ];
        };
    in
    {
      overlays.default = import ./pkgs;

      packages.${system} = {
        inherit (pkgs) openrgb-git deezer-tui xrizer-git;
      };

      formatter.${system} = pkgs.nixfmt-tree;

      # `nix flake check` builds every NixOS host and checks formatting.
      checks.${system} = {
        formatting = pkgs.runCommand "check-formatting" { } ''
          find ${self} -name '*.nix' -exec ${pkgs.lib.getExe pkgs.nixfmt} --check {} +
          touch $out
        '';
      }
      // nixpkgs.lib.mapAttrs (_: host: host.config.system.build.toplevel) self.nixosConfigurations;

      nixosConfigurations = {
        guillaume-desktop = mkHost {
          host = ./hosts/desktop;
          home = ./home/guillaume;
        };
        guillaume-laptop = mkHost {
          host = ./hosts/laptop;
          home = ./home/guillaume_laptop;
        };
      };

      darwinConfigurations.macbook = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit inputs; };
        pkgs = import nixpkgs-darwin {
          system = "aarch64-darwin";
          config.allowUnfree = true;
        };

        modules = [
          ./hosts/mac
          home-manager.darwinModules.home-manager
          (homeManagerConfig ./home/guillaume_mac)
          { home-manager.backupFileExtension = "bak"; }
        ];
      };
    };
}
