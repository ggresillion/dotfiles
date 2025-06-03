{
  description = "NixOS configuration with flakes and Home Manager for WSL";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-wsl,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          # Nix features
          {
            nix.settings.experimental-features = [
              "nix-command"
              "flakes"
            ];
          }

          # Enable nix-ld and required libraries
          {
            programs.nix-ld.enable = true;
            programs.nix-ld.libraries = with pkgs; [
              glibc
              zlib
              libglvnd
              stdenv.cc.cc
            ];
          }

          # WSL module
          nixos-wsl.nixosModules.default
          {
            wsl.enable = true;
            wsl.defaultUser = "guillaume";
            wsl.useWindowsDriver = true;
          }

          # System packages
          {
            environment.systemPackages = with pkgs; [
              lmstudio
            ];
          }

          # Docker support
          {
            virtualisation.docker.enable = true;
            users.users.guillaume.extraGroups = [ "docker" ];
          }

          # Home Manager integration
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.guillaume = import ./home.nix;
          }

          # Set system.stateVersion
          {
            system.stateVersion = "25.11"; # ⚠️ Do not change once set unless you're sure
          }
        ];
      };
    };
}
