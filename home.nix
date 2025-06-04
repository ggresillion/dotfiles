{ config, pkgs, ... }:

{
  home.username = "guillaume";
  home.homeDirectory = "/home/guillaume";

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  programs.fish = {
    enable = true;
    functions.rebuild = ''
      sudo nixos-rebuild switch --flake ~/dotfiles
    '';
  };

  xdg.configFile."fish" = {
    source = ./fish/.config/fish;
    recursive = true;
  };

  programs.git = {
    enable = true;
    userName = "Your Name";
    userEmail = "you@example.com";
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraPackages = with pkgs; [
      gcc
      nil
      stylua
      nixfmt-rfc-style
    ];
  };

  programs.starship.enable = true;

  xdg.configFile."nvim" = {
    source = ./nvim/.config/nvim;
    recursive = true;
  };
}
