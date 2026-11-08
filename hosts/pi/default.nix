{ lib, modulesPath, ... }:

{
  imports = [
    "${modulesPath}/installer/sd-card/sd-image-aarch64.nix"
    ../../modules/nixos/common/users.nix
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
  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.guillaume.extraGroups = [ "docker" ];
  # The desktop deploys here.
  users.users.guillaume.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKKUNBPaqWpps7WUFwwC8b6h9NrvotiTv8yrZ/N+JcyQ guillaume@guillaume-desktop"
  ];
  security.sudo.wheelNeedsPassword = false;

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    # Accept unsigned paths pushed from the desktop.
    trusted-users = [ "@wheel" ];
  };
  nix.optimise.automatic = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  nixpkgs.config.allowUnfree = true;

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
