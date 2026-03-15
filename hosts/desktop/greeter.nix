{ pkgs, ... }:
{
  services.xserver.enable = true;
  services.displayManager.sddm = {
    enable = true;
    theme = "noctalia";
    wayland = {
      enable = false;
    };
  };

  environment.systemPackages = with pkgs; [
    (callPackage ./noctalia-sddm-theme.nix { })
  ];
}
