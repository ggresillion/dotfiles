{
  config,
  pkgs,
  inputs,
  ...
}:

let
  limineTheme = builtins.readFile "${inputs.catppuccin-limine}/themes/mocha/catppuccin-mocha-blue.conf";
in

{
  # Extra cache for gaming-related packages (this host only)
  nix.settings = {
    substituters = [ "https://nix-gaming.cachix.org" ];
    trusted-public-keys = [ "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=" ];
  };

  # Boot: theme + Windows dual-boot chainload (this machine's disk layout)
  boot.loader.limine = {
    extraConfig = limineTheme;
    style.backdrop = "1e1e2e";

    extraEntries = ''
      /Windows
          protocol: chainload
          path: guid(378ba3bb-403c-421a-8220-6170ea7ef72c):/EFI/Microsoft/Boot/bootmgfw.efi
    '';
  };

  networking.hostName = "guillaume-desktop";

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

  # 32-bit audio for gaming
  services.pipewire.alsa.support32Bit = true;

  # Plasma (available alongside niri at the SDDM session picker)
  services.desktopManager.plasma6.enable = true;

  # Docker
  virtualisation.docker.enable = true;

  # KDE connect
  programs.kdeconnect.enable = true;

  nixpkgs.overlays = [
    (final: prev: {
      openrgb = final.callPackage ../../pkgs/openrgb-git { };
    })
  ];

  # OpenRGB: run a persistent SDK server (uses the git package above, since
  # nixpkgs' stable openrgb doesn't yet support this MSI B850 board's i2c
  # devices). This also wires up services.udev.packages so the udev rules
  # produced by the package's own build (60-openrgb.rules) actually get
  # installed system-wide, and loads i2c-piix4 for SMBus access to RAM on
  # AMD platforms - both were previously missing, which is why OpenRGB
  # couldn't see any devices without running as root.
  services.hardware.openrgb = {
    enable = true;
    package = pkgs.openrgb;
    motherboard = "amd";
  };
  # Waits for every
  systemd.services.openrgb.serviceConfig.ExecStartPre =
    "${pkgs.systemd}/bin/udevadm settle --timeout=30";
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
    sbctl
    wget
    vim
    efibootmgr

    (writeShellScriptBin "reboot-uefi" ''
      exec sudo -n systemctl reboot --firmware-setup
    '')

    (writeShellScriptBin "reboot-windows" ''
      set -e

      entry=$(sudo -n efibootmgr | awk '/Windows Boot Manager/ {
          sub(/^Boot/, "")
          sub(/\*.*/, "")
          print
      }')

      sudo -n efibootmgr --bootnext "$entry"
      sudo -n reboot
    '')
  ];

  security.sudo.extraRules = [
    {
      users = [ "guillaume" ];
      commands = [
        {
          command = "/run/current-system/sw/bin/efibootmgr";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/reboot";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/systemctl";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  programs.coolercontrol.enable = true;

  system.stateVersion = "26.05";
}
