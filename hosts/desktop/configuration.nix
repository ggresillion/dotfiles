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

  users.users.guillaume.extraGroups = [
    "video"
    "audio"
    "docker"
  ];

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

  # Plasma: available at the greeter, and also what pulls in Dolphin, Ark,
  # Breeze icons, kwallet, power-profiles-daemon and fwupd for the niri session.
  services.desktopManager.plasma6.enable = true;

  # Docker
  virtualisation.docker.enable = true;

  # KDE connect
  programs.kdeconnect.enable = true;

  # OpenRGB: run a persistent SDK server (uses openrgb-git from ../../pkgs, since
  # nixpkgs' stable openrgb doesn't yet support this MSI B850 board's i2c
  # devices). This also wires up services.udev.packages so the udev rules
  # produced by the package's own build (60-openrgb.rules) actually get
  # installed system-wide, and loads i2c-piix4 for SMBus access to RAM on
  # AMD platforms - both were previously missing, which is why OpenRGB
  # couldn't see any devices without running as root.
  services.hardware.openrgb = {
    enable = true;
    package = pkgs.openrgb-git;
    motherboard = "amd";
  };
  # Wait for udev so the i2c/USB devices exist before the server scans them.
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

  # Passwordless only for the exact invocations reboot-uefi/reboot-windows
  # make. A bare `systemctl` or `efibootmgr` rule would be passwordless root
  # (e.g. `systemctl edit` spawns an editor as root).
  security.sudo.extraRules = [
    {
      users = [ "guillaume" ];
      commands =
        map
          (command: {
            inherit command;
            options = [ "NOPASSWD" ];
          })
          [
            # `""` = no arguments allowed
            ''/run/current-system/sw/bin/efibootmgr ""''
            "/run/current-system/sw/bin/efibootmgr --bootnext [0-9A-F][0-9A-F][0-9A-F][0-9A-F]"
            ''/run/current-system/sw/bin/reboot ""''
            "/run/current-system/sw/bin/systemctl reboot --firmware-setup"
          ];
    }
  ];

  services.jackett.enable = true;

  system.stateVersion = "26.05";
}
