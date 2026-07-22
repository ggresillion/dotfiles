{ pkgs, lib, ... }:

{
  programs.niri.enable = true;

  services.xserver.enable = true;
  services.displayManager.defaultSession = "niri";

  services.displayManager.sddm = {
    enable = true;
    theme = "catppuccin-mocha-blue";
    package = lib.mkForce pkgs.kdePackages.sddm;

    extraPackages = [
      (pkgs.catppuccin-sddm.override {
        flavor = "mocha";
        accent = "blue";
      })
    ];

    wayland.enable = true;

    settings = {
      General = {
        InputMethod = "";
      };
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Prefer Wayland for electron-based apps (Vesktop, VSCode, etc.)
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  hardware.bluetooth.enable = true;

  environment.systemPackages = [
    pkgs.xwayland-satellite
    pkgs.lxqt.lxqt-policykit
    (pkgs.catppuccin-sddm.override {
      flavor = "mocha";
      accent = "blue";
    })
  ];
}
