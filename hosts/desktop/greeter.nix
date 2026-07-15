{ pkgs, lib, ... }:

{
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

  environment.systemPackages = [
    (pkgs.catppuccin-sddm.override {
      flavor = "mocha";
      accent = "blue";
    })
  ];
}
