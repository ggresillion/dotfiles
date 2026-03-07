{ config, pkgs, inputs, lib, ... }: 
let 
	  dotfiles = "${config.home.homeDirectory}/dotfiles/home/guillaume/config";
in {

    imports = [
      inputs.noctalia.homeModules.default
    ];

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
    gcc
    delve
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
    gocryptfs
    unrar
    fzf
    r2modman
    faugus-launcher
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

      programs.noctalia-shell = {
      enable = true;
      settings = {
        # configure noctalia here
        bar = {
          density = "compact";
          position = "right";
          showCapsule = false;
          widgets = {
            left = [
              {
                id = "ControlCenter";
                useDistroLogo = true;
              }
              {
                id = "Network";
              }
              {
                id = "Bluetooth";
              }
            ];
            center = [
              {
                hideUnoccupied = false;
                id = "Workspace";
                labelMode = "none";
              }
            ];
            right = [
              {
                alwaysShowPercentage = false;
                id = "Battery";
                warningThreshold = 30;
              }
              {
                formatHorizontal = "HH:mm";
                formatVertical = "HH mm";
                id = "Clock";
                useMonospacedFont = true;
                usePrimaryColor = true;
              }
            ];
          };
        };
        colorSchemes.predefinedScheme = "Monochrome";
        location = {
          monthBeforeDay = true;
          name = "Marseille, France";
        };
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
    "${dotfiles}/nvim";

  # WezTerm
  programs.wezterm = { enable = true; };
  xdg.configFile."wezterm".source = config.lib.file.mkOutOfStoreSymlink
    "${dotfiles}/wezterm";

  # Zellij
  programs.zellij = { enable = true; };
  xdg.configFile."zellij".source = config.lib.file.mkOutOfStoreSymlink
    "${dotfiles}/zellij";

  # Git
  programs.git = { enable = true; };
  xdg.configFile."git/config".source = config.lib.file.mkOutOfStoreSymlink
    "${dotfiles}/git/config";

  # Nushell
  programs.nushell.enable = true;
  xdg.configFile."nushell/autoload".source = config.lib.file.mkOutOfStoreSymlink
    "${dotfiles}/nushell/autoload";

  # Niri
  xdg.configFile."niri".source = config.lib.file.mkOutOfStoreSymlink
    "${dotfiles}/niri";

  # Starship
  xdg.configFile."starship.toml".source = config.lib.file.mkOutOfStoreSymlink
    "${dotfiles}/starship/starship.toml";

  # Direnv
  programs.direnv = {
    enable = true;
    silent = true;
    config = { global = { load_dotenv = true; }; };
  };

  programs.home-manager.enable = true;
}
