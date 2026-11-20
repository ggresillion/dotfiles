{ lib, modulesPath, ... }:

{
  imports = [
    "${modulesPath}/installer/sd-card/sd-image-aarch64.nix"
    ../../modules/nixos/base.nix
    ./homeassistant.nix
  ];

  # Raspberry Pi 3B, headless. Built on the desktop (binfmt), deployed with:
  #   nixos-rebuild switch --flake .#pi --target-host pi --build-host localhost --sudo
  nixpkgs.hostPlatform = "aarch64-linux";
  sdImage.compressImage = false;
  hardware.enableRedistributableFirmware = true;
  # The installer profile enables ZFS; not needed here.
  boot.supportedFilesystems.zfs = lib.mkForce false;

  networking.hostName = "pi";

  users.users.guillaume.extraGroups = [ "docker" ];
  security.sudo.wheelNeedsPassword = false;

  # Accept unsigned paths pushed from the desktop.
  nix.settings.trusted-users = [ "@wheel" ];
  nix.gc.options = "--delete-older-than 7d";

  # 1 GB RAM and an SD card: swap in RAM, keep writes low.
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };
  boot.kernel.sysctl = {
    "vm.swappiness" = 100;
    "vm.page-cluster" = 0;
  };
  services.journald.settings.Journal.SystemMaxUse = "100M";
  documentation.enable = false;

  system.stateVersion = "26.11";
}
