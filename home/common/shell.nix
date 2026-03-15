{
  config,
  pkgs,
  inputs,
  lib,
  dotfiles,
  ...
}:

{
  home.packages = with pkgs; [
    ripgrep
    fzf
    jq
    carapace
    starship
    zoxide
    inputs.nixwrap.packages.${pkgs.stdenv.hostPlatform.system}.wrap
  ];

  # Aliases
  home.shellAliases = {
    g = "git";
    d = "docker";
    dc = "docker compose";
    rebuild = "sudo nixos-rebuild switch --flake ~/dotfiles";
    wrap = lib.getExe inputs.nixwrap.packages.${pkgs.stdenv.hostPlatform.system}.wrap;
  };

  # Direnv
  programs.direnv = {
    enable = true;
    silent = true;
    config = {
      global = {
        load_dotenv = true;
      };
    };
  };

  # Nushell
  programs.nushell.enable = true;
  xdg.configFile."nushell/autoload".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/nushell/.config/nushell/autoload";

  # Starship
  xdg.configFile."starship.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/starship/.config/starship.toml";

  # Zellij
  programs.zellij = {
    enable = true;
  };
  xdg.configFile."zellij".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/zellij/.config/zellij";

  # Git
  programs.git = {
    enable = true;
  };
  xdg.configFile."git/config".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/git/.config/git/config";

  # Neovim
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default;
    extraPackages = with pkgs; [
      nodejs
      python3
      gcc
      tree-sitter
      nixd
      nixfmt
    ];
  };
  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/nvim/.config/nvim";

  # WezTerm
  programs.wezterm = {
    enable = true;
  };
  xdg.configFile."wezterm".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/wezterm/.config/wezterm";
}
