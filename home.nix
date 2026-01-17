{ config, pkgs, system, inputs, ... }: {
  home.username = "guillaume";
  home.homeDirectory = "/home/guillaume";
  home.stateVersion = "24.11";

  # Basic packages
  home.packages = with pkgs; [
    wl-clipboard
    inputs.zen-browser.packages."${system}".default
    discord
    starship
    zoxide
    deezer-enhanced
    unzip
    go
    lazygit
  ];

  # Neovim - basic setup
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
    extraPackages = with pkgs; [ nodejs python3 gcc tree-sitter nixd ];
  };

  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/dotfiles/nvim/.config/nvim";

  # WezTerm - minimal config
  programs.wezterm = { enable = true; };

  # Zellij - minimal config
  programs.zellij = { enable = true; };

  # Git
  programs.git = { enable = true; };

  programs.nushell.enable = true;

  # xdg.configFile."niri".source = ./niri/.config/niri;
  xdg.configFile."wezterm".source = ./wezterm/.config/wezterm;
  xdg.configFile."git".source = ./git/.config/git;
  xdg.configFile."nushell".source = ./nushell/.config/nushell;
  xdg.configFile."starship".source = ./starship/.config/starship;
  xdg.configFile."zellij".source = ./zellij/.config/zellij;
  # xdg.configFile."fish".source = ./fish/.config/fish;
  # xdg.configFile."hyprland".source = ./hyprland/.config/hypr;

  home.sessionVariables.STARSHIP_CONFIG = "~/.config/starship/starship.toml";

  programs.home-manager.enable = true;
}
