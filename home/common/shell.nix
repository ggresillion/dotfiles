{
  pkgs,
  inputs,
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
  ] ++ pkgs.lib.optionals (!pkgs.stdenv.isDarwin) [
    inputs.nixwrap.packages.${pkgs.stdenv.hostPlatform.system}.wrap
  ];

  # Aliases
  home.shellAliases = {
    g = "git";
    d = "docker";
    dc = "docker compose";
    nswitch = "sudo nixos-rebuild switch --flake /home/guillaume/nixos";
    nupdate = "nix flake update /etc/nixos and sudo nixos-rebuild switch --flake /etc/nixos";
    nedit = "nvim /etc/nixos";
    nd = "nix develop path:. --command $env.SHELL";
  };
  # Note: nswitch/nedit overridden in darwin home config

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
  xdg.configFile."nushell/autoload".source = ./config/nushell/autoload;

  # Starship
  xdg.configFile."starship.toml" = {
    source = ./config/starship/starship.toml;
    force = true;
  };

  # Zellij
  programs.zellij = {
    enable = true;
  };
  xdg.configFile."zellij".source = ./config/zellij;

  # Git
  programs.git = {
    enable = true;
  };
  xdg.configFile."git/config".source = ./config/git/config;

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
  xdg.configFile = {
    "nvim/init.lua" = {
      source = ./config/nvim/init.lua;
      force = true;
    };
    "nvim/lua" = {
      source = ./config/nvim/lua;
      force = true;
    };
    "nvim/colors" = {
      source = ./config/nvim/colors;
      force = true;
    };
    "nvim/snippets" = {
      source = ./config/nvim/snippets;
      force = true;
    };
  };

  # WezTerm — package managed by homebrew on darwin
  programs.wezterm = pkgs.lib.mkIf (!pkgs.stdenv.isDarwin) {
    enable = true;
  };
  xdg.configFile."wezterm/wezterm.lua" = {
    source = ./config/wezterm/wezterm.lua;
    force = true;
  };
}
