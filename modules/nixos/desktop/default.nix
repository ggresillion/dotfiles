{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

# niri desktop with the dux (dms) shell and greeter. The shell itself is set
# up in home-manager (modules/home/desktop).
{
  imports = [ inputs.dux-greeter.nixosModules.default ];

  programs.niri.enable = true;
  services.displayManager.defaultSession = lib.mkForce "niri";

  programs.dms-greeter = {
    enable = true;
    compositor.name = "niri";
    # Copies the Dux Shell theme and wallpaper into the greeter.
    configHome = config.users.users.guillaume.home;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Prefer Wayland for electron-based apps (Vesktop, VSCode, etc.)
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  hardware.graphics.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  hardware.bluetooth.enable = true;
  hardware.xpadneo.enable = true;
  # Lets `qmk flash` reach keyboard bootloaders without sudo.
  hardware.keyboard.qmk.enable = true;

  services.power-profiles-daemon.enable = true;
  services.udisks2.enable = true;

  environment.systemPackages = [
    pkgs.xwayland-satellite
    pkgs.lxqt.lxqt-policykit
    pkgs.udiskie
  ];
}
