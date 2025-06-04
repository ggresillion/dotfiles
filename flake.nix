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
            nixpkgs.config.allowUnfree = true;
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

          # Set default shell
          {
            users.users.guillaume = {
              shell = pkgs.fish;
              ignoreShellProgramCheck = true;
            };
          }

          # System packages
          {
            environment.systemPackages = with pkgs; [
              lmstudio
              (ollama.override {
                acceleration = "cuda";
              })
            ];
          }

          # Docker support
          {
            virtualisation.docker.enable = true;
            users.users.guillaume.extraGroups = [ "docker" ];
          }

          # CUDA support
          {
            services.xserver.videoDrivers = [ "nvidia" ];
            hardware.nvidia.open = true;

            environment.sessionVariables = {
              CUDA_PATH = "${pkgs.cudatoolkit}";
              EXTRA_LDFLAGS = "-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib";
              EXTRA_CCFLAGS = "-I/usr/include";
              LD_LIBRARY_PATH = [
                "/usr/lib/wsl/lib"
                "${pkgs.linuxPackages.nvidia_x11}/lib"
                "${pkgs.ncurses5}/lib"
              ];
              MESA_D3D12_DEFAULT_ADAPTER_NAME = "Nvidia";
            };

            hardware.nvidia-container-toolkit = {
              enable = true;
              mount-nvidia-executables = false;
            };

            systemd.services = {
              nvidia-cdi-generator = {
                description = "Generate nvidia cdi";
                wantedBy = [ "docker.service" ];
                serviceConfig = {
                  Type = "oneshot";
                  ExecStart = "${pkgs.nvidia-docker}/bin/nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml --nvidia-ctk-path=${pkgs.nvidia-container-toolkit}/bin/nvidia-ctk";
                };
              };
            };

            virtualisation.docker = {
              daemon.settings.features.cdi = true;
              daemon.settings.cdi-spec-dirs = [ "/etc/cdi" ];
            };
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
