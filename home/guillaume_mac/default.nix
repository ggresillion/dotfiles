{ pkgs, inputs, lib, ... }:
{
  imports = [
    ../common/shell.nix
    ../common/dev.nix
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

  # Mac-specific shell aliases (override common)
  home.shellAliases = {
    nswitch = lib.mkForce "darwin-rebuild switch --flake ~/dotfiles#macbook";
    nedit = lib.mkForce "nvim ~/dotfiles";
  };

  # Aerospace config (window manager)
  home.file.".aerospace.toml".source = ../common/config/aerospace/.config/.aerospace.toml;

  # Remove stale symlink left by older home-manager before copyApps creates real dir
  home.activation.removeHomeManagerAppsLink = lib.hm.dag.entryBefore ["copyApps"] ''
    if [ -L "$HOME/Applications/Home Manager Apps" ]; then
      $DRY_RUN_CMD rm "$HOME/Applications/Home Manager Apps"
    fi
  '';
}
