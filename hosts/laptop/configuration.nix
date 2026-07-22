{
  config,
  pkgs,
  ...
}:

{
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
  };
  nix.optimise.automatic = true;

  # Boot
  boot.loader.limine = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    maxGenerations = 2;
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

  # Networking
  networking.hostName = "guillaume-laptop";
  networking = {
    networkmanager.enable = true;

    # Use the local dnsmasq instance
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

  # User
  users.users = {
    guillaume = {
      isNormalUser = true;
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      hashedPassword = "$6$QApRfgdVjtrm1BwC$/6fJuQSpiMFDExYF5G66nbL72/LqZvtHn.ThWKwt2AbmxxUyezr/nhMEsMymteyyvCdnYDI8lSlrfJ6X8Un7u.";
      shell = "${pkgs.nushell}/bin/nu";
    };
  };

  # Laptop battery management
  services.power-profiles-daemon.enable = true;

  # Graphics
  hardware.graphics.enable = true;

  # Niri
  programs.niri.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Prefer Wayland for electron-based apps (Vesktop, VSCode, etc.)
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Sound
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # Bluetooth
  hardware.bluetooth.enable = true;

  # Nix settings
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
    "ca-derivations"
  ];
  nixpkgs.config.allowUnfree = true;

  # Basic packages
  environment.systemPackages = with pkgs; [
    git
    sbctl
    wget
    vim
    xwayland-satellite
    lxqt.lxqt-policykit
  ];

  system.stateVersion = "26.05";
}
