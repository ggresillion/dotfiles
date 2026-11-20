{
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

  # Build the Raspberry Pi host (aarch64) locally through QEMU.
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # AMD
  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.graphics.enable32Bit = true;
  # enable tweaking
  hardware.amdgpu.overdrive.enable = true;

  # 32-bit audio for gaming
  services.pipewire.alsa.support32Bit = true;

  services.fwupd.enable = true;
  services.upower.enable = true;

  # Docker
  virtualisation.docker.enable = true;

  # KDE connect
  programs.kdeconnect.enable = true;

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      # GL / EGL / Vulkan
      libGL
      libGLU
      libglvnd # libEGL.so.1
      vulkan-loader
      # vulkan-validation-layers removed: only useful to debug Vulkan apps.

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

  system.stateVersion = "26.05";
}
