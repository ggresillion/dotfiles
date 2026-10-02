{
  config,
  pkgs,
  ...
}:

{
  networking.hostName = "guillaume-laptop";

  # Laptop battery management
  services.power-profiles-daemon.enable = true;

  hardware.graphics.enable = true;

  # Basic packages
  environment.systemPackages = with pkgs; [
    git
    sbctl
    wget
    vim
  ];

  system.stateVersion = "26.05";
}
