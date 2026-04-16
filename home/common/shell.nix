{
  config,
  pkgs,
  inputs,
  lib,
  flakeRoot,
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
    nswitch = "sudo nixos-rebuild switch --flake /etc/nixos";
    nedit = "sudo -E nvim /etc/nixos";
    nd = "nix develop path:. --command $env.SHELL";
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
    config.lib.file.mkOutOfStoreSymlink "${flakeRoot}/home/common/config/nushell/.config/nushell/autoload";

  # Starship
  xdg.configFile."starship.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${flakeRoot}/home/common/config/starship/.config/starship.toml";

  # Zellij
  programs.zellij = {
    enable = true;
  };
  xdg.configFile."zellij".source =
    config.lib.file.mkOutOfStoreSymlink "${flakeRoot}/home/common/config/zellij/.config/zellij";

  # Git
  programs.git = {
    enable = true;
  };
  xdg.configFile."git/config".source =
    config.lib.file.mkOutOfStoreSymlink "${flakeRoot}/home/common/config/git/.config/git/config";

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
      source = "${flakeRoot}/home/common/config/nvim/.config/nvim/init.lua";
      force = true;
    };
    "nvim/lua" = {
      source = "${flakeRoot}/home/common/config/nvim/.config/nvim/lua";
      force = true;
    };
    "nvim/colors" = {
      source = "${flakeRoot}/home/common/config/nvim/.config/nvim/colors";
      force = true;
    };
    "nvim/snippets" = {
      source = "${flakeRoot}/home/common/config/nvim/.config/nvim/snippets";
      force = true;
    };
  };

  # WezTerm
  programs.wezterm = {
    enable = true;
  };
  xdg.configFile."wezterm".source =
    config.lib.file.mkOutOfStoreSymlink "${flakeRoot}/home/common/config/wezterm/.config/wezterm";
}
