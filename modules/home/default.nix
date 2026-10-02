{ lib, ... }:

# Shell and dev tools are always on; everything else is opt-in per machine
# via `profiles.<name>.enable` in home/<user>/default.nix.
{
  imports = [
    ./shell.nix
    ./dev.nix
    ./desktop.nix
    ./keyboard-compose.nix
    ./apps.nix
    ./gaming.nix
    ./rgb.nix
  ];

  options.profiles = {
    desktop.enable = lib.mkEnableOption "the niri + noctalia Wayland desktop";
    apps.enable = lib.mkEnableOption "everyday GUI and CLI apps";
    apps.extras.enable = lib.mkEnableOption "extra apps (chat, torrents, media, monitoring)";
    gaming.enable = lib.mkEnableOption "game launchers and tools";
    rgb.enable = lib.mkEnableOption "OpenRGB color sync with the noctalia palette";
  };

  config = {
    programs.home-manager.enable = true;
    home.enableNixpkgsReleaseCheck = false;
  };
}
