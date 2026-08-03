{
  pkgs,
  inputs,
  lib,
  ...
}:
{
  imports = [
    ../../modules/home/shell.nix
    ../../modules/home/dev.nix
  ];

  home.username = "guillaume";
  home.homeDirectory = "/Users/guillaume";
  home.stateVersion = "26.05";

  # Nix-only CLI packages (everything else is managed by homebrew in hosts/mac)
  home.packages = with pkgs; [
    bat
    eza
    fd
    btop
    yazi
    helix
  ];

  # Aerospace config (window manager)
  home.file.".aerospace.toml".source = ../../modules/home/config/aerospace/.aerospace.toml;

  # OmniWM (window manager) config
  xdg.configFile."omniwm/settings.toml".source = ../../modules/home/config/omniwm/settings.toml;

  # Karabiner-Elements config
  xdg.configFile."karabiner/karabiner.json".source = ../../modules/home/config/karabiner/karabiner.json;

  # Remove stale symlink left by older home-manager before copyApps creates real dir
  home.activation.removeHomeManagerAppsLink = lib.hm.dag.entryBefore [ "copyApps" ] ''
    if [ -L "$HOME/Applications/Home Manager Apps" ]; then
      $DRY_RUN_CMD rm "$HOME/Applications/Home Manager Apps"
    fi
  '';
}
