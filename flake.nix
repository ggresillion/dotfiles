{
  description = "my nix system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    darwin.url = "github:lnl7/nix-darwin";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, darwin, home-manager }: let
    system = "aarch64-darwin";
    username = "guillaume";
    pkgs = import nixpkgs {
      inherit system;
    };
  in {
    darwinConfigurations."Guillaumes-MacBook-Pro" = darwin.lib.darwinSystem {
      inherit system;
      modules = [
        {
          nix.settings.experimental-features = [ "nix-command" "flakes" ];
        }
        {
          system.stateVersion = 6;
        }

        home-manager.darwinModules.home-manager

        {
          users.users.${username} = {
            name = username;
            home = "/Users/${username}";
          };

          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.${username} = { pkgs, ... }: {
            home.stateVersion = "23.11";
            programs.fish.enable = true;
            home.packages = [
              pkgs.git
              pkgs.htop
              pkgs.neovim
            ];
          };
        }
      ];
    };
  };
}

