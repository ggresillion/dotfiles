{ config, pkgs, ... }:

{

  # Cache
  nix.settings = {
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://cache.nixos-cuda.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
    ];
  };

  # Boot
  boot.loader = {
    grub = {
      enable = true;
      efiSupport = true;
      efiInstallAsRemovable = true;
      device = "nodev";
    };
  };

  # Networking
  networking.hostName = "guillaume-desktop";
  networking.networkmanager.enable = true;

  # Time & Locale
  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "en_US.UTF-8";

  # User
  users.users.guillaume = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "docker" ];
    hashedPassword =
      "$6$QApRfgdVjtrm1BwC$/6fJuQSpiMFDExYF5G66nbL72/LqZvtHn.ThWKwt2AbmxxUyezr/nhMEsMymteyyvCdnYDI8lSlrfJ6X8Un7u.";
    shell = "${pkgs.nushell}/bin/nu";
  };

  # NVIDIA
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  hardware.graphics = { enable = true; };

  # Niri
  programs.niri.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # DMS
  programs.dms-shell = {
    enable = true;
    enableSystemMonitoring = true; # System monitoring widgets (dgop)
    enableVPN = true; # VPN management widget
    enableDynamicTheming = true; # Wallpaper-based theming (matugen)
    enableAudioWavelength = true; # Audio visualizer (cava)
    enableCalendarEvents = true; # Calendar integration (khal)
  };

  # Greeter
  services.displayManager.dms-greeter = {
    enable = true;
    compositor = { name = "niri"; };
    configHome = "/home/guillaume";
  };

  #KDE
  services.desktopManager.plasma6.enable = true;

  # Sound
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # VPN
  networking.wg-quick.interfaces.wg0.configFile =
    "/home/guillaume/wg-CH-FREE-1.conf";

  # Docker
  virtualisation.docker.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;

  # Nix settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # Basic packages
  environment.systemPackages = with pkgs; [ git wget vim xwayland-satellite ];

  system.stateVersion = "24.11";
}
