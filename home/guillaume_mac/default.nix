{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  imports = [ ../../modules/home ];

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

  # OmniWM (window manager) config, symlinked out of the store so OmniWM can write to it
  xdg.configFile."omniwm/settings.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/modules/home/config/omniwm/settings.toml";

  # Karabiner-Elements config
  xdg.configFile."karabiner/karabiner.json".source =
    ../../modules/home/config/karabiner/karabiner.json;

  # Remove stale symlink left by older home-manager before copyApps creates real dir
  home.activation.removeHomeManagerAppsLink = lib.hm.dag.entryBefore [ "copyApps" ] ''
    if [ -L "$HOME/Applications/Home Manager Apps" ]; then
      $DRY_RUN_CMD rm "$HOME/Applications/Home Manager Apps"
    fi
  '';
}
