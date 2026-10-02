{ pkgs, ... }:

{
  imports = [
    ./users.nix
    ./snapshots.nix
  ];

  # Cache & performance
  nix.settings = {
    max-jobs = "auto";
    max-substitution-jobs = 64;
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
  nix.optimise.automatic = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
  nixpkgs.config.allowUnfree = true;

  # Boot — hosts add their own extraConfig/theme/entries on top of this
  boot.loader.limine = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    # Limited by the 512M ESP: each distinct kernel+initrd is copied there.
    maxGenerations = 5;
    secureBoot = {
      enable = true;
      autoGenerateKeys = true;
    };
  };

  # SSH
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    openFirewall = true;
  };

  # Networking — use the local dnsmasq instance
  networking = {
    networkmanager.enable = true;
    nameservers = [
      "127.0.0.1"
      "::1"
    ];
  };

  services.dnsmasq = {
    enable = true;

    settings = {
      no-resolv = true;

      server = [
        "1.1.1.1"
        "1.0.0.1"
        "2606:4700:4700::1111"
        "2606:4700:4700::1001"
      ];

      cache-size = 1000;

      listen-address = [
        "127.0.0.1"
        "::1"
      ];

      bind-interfaces = true;
    };
  };

  # Speed up boot
  systemd.services.NetworkManager-wait-online.enable = false;
  services.timesyncd.enable = false;
  services.chrony.enable = true;
  systemd.oomd.enable = false;

  # Time & Locale
  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "en_US.UTF-8";

  # Shells
  environment.shells = with pkgs; [
    bash
    nushell
  ];
}
