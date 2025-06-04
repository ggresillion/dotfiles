{
  description = "My nix system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    darwin.url = "github:lnl7/nix-darwin";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      darwin,
      nixos-wsl,
      home-manager,
    }:
    let
      username = "guillaume";
      sharedConfig = {
        nix.settings.experimental-features = [
          "nix-command"
          "flakes"
        ];
        nixpkgs.config.allowUnfree = true;
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.${username} = import ./home.nix;
        home-manager.backupFileExtension = "bck";
        users.users.${username} = {
          shell = nixpkgs.legacyPackages.x86_64-linux.fish;
        };
        programs.fish.enable = true;
      };
    in
    {
      darwinConfigurations."Guillaumes-MacBook-Pro" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [

          home-manager.darwinModules.home-manager

          {
            users.users.guillaume = {
              name = "guillaume";
              home = "/Users/guillaume";
            };
          }

          sharedConfig

          {
            system.stateVersion = 6;
          }
        ];
      };

      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          # WSL
          nixos-wsl.nixosModules.default
          {
            wsl.enable = true;
            wsl.defaultUser = "guillaume";
            wsl.useWindowsDriver = true;
          }

          # System packages
          {
            environment.systemPackages = with nixpkgs.legacyPackages.x86_64-linux; [
              (ollama.override { acceleration = "cuda"; })
            ];
          }

          # Docker
          {
            virtualisation.docker.enable = true;
            users.users.guillaume.extraGroups = [ "docker" ];
          }

          # Nvidia SMI
          {
            programs.nix-ld.enable = true;
            programs.nix-ld.libraries = with nixpkgs.legacyPackages.x86_64-linux; [
              glibc
              zlib
              libglvnd
              stdenv.cc.cc
            ];
          }

          # Nvidia CDI
          {
            services.xserver.videoDrivers = [ "nvidia" ];
            hardware.nvidia.open = true;

            environment.sessionVariables = {
              CUDA_PATH = "${nixpkgs.legacyPackages.x86_64-linux.cudatoolkit}";
              EXTRA_LDFLAGS = "-L/lib -L${nixpkgs.legacyPackages.x86_64-linux.linuxPackages.nvidia_x11}/lib";
              EXTRA_CCFLAGS = "-I/usr/include";
              LD_LIBRARY_PATH = [
                "/usr/lib/wsl/lib"
                "${nixpkgs.legacyPackages.x86_64-linux.linuxPackages.nvidia_x11}/lib"
                "${nixpkgs.legacyPackages.x86_64-linux.ncurses5}/lib"
              ];
              MESA_D3D12_DEFAULT_ADAPTER_NAME = "Nvidia";
            };

            hardware.nvidia-container-toolkit = {
              enable = true;
              mount-nvidia-executables = false;
            };

            systemd.services.nvidia-cdi-generator = {
              description = "Generate nvidia cdi";
              wantedBy = [ "docker.service" ];
              serviceConfig = {
                Type = "oneshot";
                ExecStart = "${nixpkgs.legacyPackages.x86_64-linux.nvidia-docker}/bin/nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml --nvidia-ctk-path=${nixpkgs.legacyPackages.x86_64-linux.nvidia-container-toolkit}/bin/nvidia-ctk";
              };
            };

            virtualisation.docker.daemon.settings = {
              features.cdi = true;
              "cdi-spec-dirs" = [ "/etc/cdi" ];
            };
          }
          {
            system.stateVersion = "25.11";
          }
        ];
      };
    };
}
