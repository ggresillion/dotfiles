{ config, pkgs, inputs, lib, ... }: {
  home.username = "guillaume";
  home.homeDirectory = "/home/guillaume";
  home.stateVersion = "24.11";

  # Basic packages
  home.packages = with pkgs; [
    wl-clipboard
    inputs.zen-browser.packages."${stdenv.hostPlatform.system}".default
    discord
    starship
    zoxide
    deezer-enhanced
    unzip
    p7zip
    go
    lazygit
    github-cli
    carapace
    nvtopPackages.nvidia
    ripgrep
    inputs.nixwrap.packages.${pkgs.stdenv.hostPlatform.system}.wrap
    # linux-wallpaperengine
    umu-launcher
    kdePackages.gwenview
    godot
  ];

  # Aliases
  home.shellAliases = {
    g = "git";
    d = "docker";
    dc = "docker compose";
    rebuild = "sudo nixos-rebuild switch --flake ~/dotfiles";
    wrap = lib.getExe
      inputs.nixwrap.packages.${pkgs.stdenv.hostPlatform.system}.wrap;
  };

  # Neovim
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    package =
      inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default;
    extraPackages = with pkgs; [ nodejs python3 gcc tree-sitter nixd ];
  };

  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/dotfiles/nvim/.config/nvim";

  # WezTerm
  programs.wezterm = { enable = true; };
  xdg.configFile."wezterm".source = ./wezterm/.config/wezterm;

  # Zellij
  programs.zellij = { enable = true; };

  # Git
  programs.git = { enable = true; };
  xdg.configFile."git".source = ./git/.config/git;

  # Nushell
  programs.nushell.enable = true;
  xdg.configFile."nushell/autoload".source = config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/dotfiles/nushell/.config/nushell/autoload";

  # Niri
  xdg.configFile."niri".source = config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/dotfiles/niri/.config/niri";

  # Starship
  xdg.configFile."starship.toml".source = ./starship/.config/starship.toml;

  # Zellij
  xdg.configFile."zellij".source = ./zellij/.config/zellij;

  programs.home-manager.enable = true;
}
