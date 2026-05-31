{
  config,
  pkgs,
  ...
}:

{

  # Cache
  nix.settings = {
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  # Boot
  boot.loader = {
    grub = {
      enable = true;
      efiSupport = true;
      efiInstallAsRemovable = true;
      device = "nodev";
      useOSProber = true;
    };
  };

  # Networking
  networking.hostName = "guillaume-desktop";
  networking.networkmanager.enable = true;

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
        "video"
        "audio"
        "docker"
      ];
      hashedPassword = "$6$QApRfgdVjtrm1BwC$/6fJuQSpiMFDExYF5G66nbL72/LqZvtHn.ThWKwt2AbmxxUyezr/nhMEsMymteyyvCdnYDI8lSlrfJ6X8Un7u.";
      shell = "${pkgs.nushell}/bin/nu";
    };
  };

  # AMD
  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  # enable tweaking
  hardware.amdgpu.overdrive.enable = true;

  # Niri
  programs.niri.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Plasma
  services.desktopManager.plasma6.enable = true;

  # Sound
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Docker
  virtualisation.docker.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;

  # KDE connect
  programs.kdeconnect.enable = true;

  # Nix settings
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.config.allowUnfree = true;
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      # GL / EGL / Vulkan
      libGL
      libGLU
      libglvnd # libEGL.so.1
      vulkan-loader
      vulkan-validation-layers

      # X11 family
      libx11 # also provides libX11-xcb.so.1
      libxext
      libxrender
      libxi
      libxfixes
      libxcursor
      libxrandr
      libxinerama
      libxcb
      libsm
      libice

      # xcb extras
      libxkbcommon
      xcb-util-cursor

      # C / C++ runtimes
      stdenv.cc.cc.lib # libstdc++.so.6
      libgcc.lib # libgcc_s.so.1

      # Core libs
      zlib
      glib # libglib-2.0.so.0 + libgthread-2.0.so.0
      dbus # libdbus-1.so.3

      # Fonts
      fontconfig
      freetype

      # Audio
      alsa-lib
      pulseaudio

      # System
      udev
    ];
  };

  # Basic packages
  environment.systemPackages = with pkgs; [
    git
    wget
    vim
    xwayland-satellite
    lxqt.lxqt-policykit
  ];

  system.stateVersion = "26.05";
}
