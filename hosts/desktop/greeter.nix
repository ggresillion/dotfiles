{ pkgs, ... }:

let
  noctaliaTheme = pkgs.callPackage ./noctalia-sddm-theme.nix { };
in
{
  services.xserver.enable = true;

  services.displayManager.defaultSession = "niri";

  services.displayManager.sddm = {
    enable = true;
    theme = "breeze";

    extraPackages = [
      # noctaliaTheme
      # pkgs.qt6.qt5compat
    ];

    wayland.enable = true;

    settings = {
      General = {
        InputMethod = "";
      };
    };
  };
}
