{ pkgs, ... }:

let
  noctaliaTheme = pkgs.callPackage ./noctalia-sddm-theme.nix { };
in
{
  services.xserver.enable = true;

  services.displayManager.sddm = {
    enable = true;
    theme = "noctalia";

    extraPackages = [
      noctaliaTheme
      pkgs.qt6.qt5compat
    ];

    wayland.enable = false;
  };

  environment.systemPackages = [
    noctaliaTheme
  ];
}
