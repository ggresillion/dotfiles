{ config, lib, pkgs, ... }:

{
  imports = [
    <nixos-wsl/modules>
    <home-manager/nixos>
  ];

  users.users.guillaume = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
  };

  virtualisation.docker.enable = true;

  home-manager.users.guillaume = { pkgs, lib, config, ... }: {
    home.packages = [
      pkgs.htop
      pkgs.gcc
      pkgs.go
    ];

    programs = {
      home-manager = {
        enable = true;
      };
      git = {
        enable = true;
      };
      neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;
      };
      tmux = {
        enable = true;
        shell = "${pkgs.fish}/bin/fish";
        extraConfig = builtins.readFile ./dot_tmux.conf;
      };
      fish = {
        enable = true;
        interactiveShellInit = ''
            set fish_greeting # Disable greeting
            fish_config theme choose "catppuccin"
        '';
      };
     };


    home.file = {
      ".config/nvim".source = ./dot_config/nvim;
      ".config/fish/themes/catppuccin.theme".source = builtins.fetchurl {
        url = "https://raw.githubusercontent.com/catppuccin/fish/main/themes/Catppuccin%20Frappe.theme";
        name = "catppuccin.theme";
      };
      ".tmux/plugins/tpm".source = builtins.fetchGit {
        url = "https://github.com/tmux-plugins/tpm";
        ref = "master";
      };
    };

    home.stateVersion = "23.05";
  };

  wsl.enable = true;
  wsl.defaultUser = "guillaume";

  system.stateVersion = "23.05";
}
