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
    "${config.home.homeDirectory}/dotfiles/dotfiles/nvim";

  # WezTerm
  programs.wezterm = { enable = true; };
  xdg.configFile."wezterm".source = config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/dotfiles/dotfiles/wezterm";

  # Zellij
  programs.zellij = { enable = true; };
  xdg.configFile."zellij".source = config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/dotfiles/dotfiles/zellij";

  # Git
  programs.git = { enable = true; };
  home.file.".gitconfig".source = config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/dotfiles/dotfiles/git/gitconfig";

  # Nushell
  programs.nushell.enable = true;
  xdg.configFile."nushell/autoload".source = config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/dotfiles/dotfiles/nushell/autoload";

  # Niri
  xdg.configFile."niri".source = config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/dotfiles/dotfiles/niri";

  # Starship
  xdg.configFile."starship.toml".source = config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/dotfiles/dotfiles/starship/starship.toml";

  programs.home-manager.enable = true;
}
