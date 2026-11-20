{
  config,
  pkgs,
  inputs,
  ...
}:
{
  home.packages =
    with pkgs;
    [
      ripgrep
      fzf
      jq
    ]
    ++ pkgs.lib.optionals (!pkgs.stdenv.hostPlatform.isDarwin) [
      inputs.nixwrap.packages.${pkgs.stdenv.hostPlatform.system}.wrap
    ];

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
  programs.nushell = {
    enable = true;
    loadSessionVariables = true;
  };
  # Aliases (nushell syntax)
  programs.nushell.shellAliases = {
    g = "git";
    d = "docker";
    dc = "docker compose";
    nrs =
      if pkgs.stdenv.hostPlatform.isDarwin then
        "sudo /run/current-system/sw/bin/darwin-rebuild switch --flake ${config.home.homeDirectory}/nixos#(hostname)"
      else
        "sudo nixos-rebuild switch --flake ${config.home.homeDirectory}/nixos#(hostname)";
    nrt =
      if pkgs.stdenv.hostPlatform.isDarwin then
        "darwin-rebuild build --flake ${config.home.homeDirectory}/nixos#(hostname)"
      else
        "sudo nixos-rebuild test --flake ${config.home.homeDirectory}/nixos#(hostname)";
    nfu = "nix flake update --flake ${config.home.homeDirectory}/nixos";
    nd = "nix develop path:. --command $env.SHELL";
  };

  xdg.configFile."nushell/autoload".source = ./config/nushell/autoload;

  # Shell integrations — init scripts are generated at build time into config.nu
  programs.starship.enable = true;
  programs.zoxide.enable = true;
  programs.carapace = {
    enable = true;
    environment.CARAPACE_BRIDGES = "zsh,fish,bash";
  };

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

  # Tmux
  xdg.configFile."tmux/which-key.yaml".source = ./config/tmux/which-key.yaml;

  programs.tmux = {
    enable = true;
    plugins = with pkgs.tmuxPlugins; [ tmux-which-key ];
    extraConfig = builtins.readFile ./config/tmux/tmux.conf;
  };

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
    package = pkgs.neovim-unwrapped;
    extraPackages = with pkgs; [
      python3
      gcc
      tree-sitter
      nixd
      nixfmt
      lua-language-server
      gopls
      gofumpt
      gotools
      golangci-lint
      golangci-lint-langserver
      typescript-language-server
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
  programs.wezterm = pkgs.lib.mkIf (!pkgs.stdenv.hostPlatform.isDarwin) {
    enable = true;
  };
  xdg.configFile."wezterm/wezterm.lua" = {
    source = ./config/wezterm/wezterm.lua;
    force = true;
  };

  xdg.configFile."tridactyl/tridactylrc".source = ./config/tridactyl/tridactylrc;

  # Raycast script command — new WezTerm window without a cold process spawn
  home.file."scripts/open-wezterm-window.sh" = pkgs.lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    source = ./config/raycast/open-wezterm-window.sh;
    executable = true;
    force = true;
  };
}
