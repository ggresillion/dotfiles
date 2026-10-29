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

  # "noctalia" or "dux"; the greeter follows the shell unless set.
  desktop.shell = "dux";
  desktop.greeter = "dux";

  # No Plasma: its kded modules override Noctalia's dark theme. The KDE apps
  # it used to pull in are listed in systemPackages below.
  # Dolphin's "Open With" menu is empty without a menu definition.
  environment.etc."xdg/menus/applications.menu".source =
    "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
  services.power-profiles-daemon.enable = true;
  services.fwupd.enable = true;
  services.upower.enable = true;

  # Docker
  virtualisation.docker.enable = true;

  # KDE connect
  programs.kdeconnect.enable = true;

  # openrgb-git: nixpkgs' openrgb lacks this MSI B850 board's i2c devices.
  services.hardware.openrgb = {
    enable = true;
    package = pkgs.openrgb-git;
    motherboard = "amd";
  };
  # Let the devices appear before the server scans them.
  systemd.services.openrgb.serviceConfig.ExecStartPre =
    "${pkgs.systemd}/bin/udevadm settle --timeout=30";

  # Apply the RGB mode (pkgs/rgb) whenever the server starts and after resume.
  systemd.services.rgb =
    let
      sleepTargets = [
        "suspend.target"
        "hibernate.target"
        "hybrid-sleep.target"
        "suspend-then-hibernate.target"
      ];
    in
    {
      after = [ "openrgb.service" ] ++ sleepTargets;
      requires = [ "openrgb.service" ];
      wantedBy = [ "openrgb.service" ] ++ sleepTargets;
      environment = {
        XDG_CONFIG_HOME = "/run/rgb";
        XDG_STATE_HOME = "${config.users.users.guillaume.home}/.local/state";
      };
      serviceConfig = {
        Type = "oneshot";
        RuntimeDirectory = "rgb";
        ExecStart = "${pkgs.lib.getExe pkgs.rgb} apply --wait";
      };
    };

  # The server only detects devices at startup: restart it on keyboard replug.
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="0e20", RUN+="${pkgs.systemd}/bin/systemctl --no-block try-restart openrgb.service"
  '';

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

  # Basic packages
  environment.systemPackages = with pkgs; [
    git
    sbctl
    wget
    vim
    efibootmgr

    kdePackages.dolphin
    kdePackages.dolphin-plugins
    kdePackages.ark
    kdePackages.breeze-icons
    kdePackages.kio-extras
    kdePackages.kio-fuse
    kdePackages.ffmpegthumbs
    kdePackages.kdegraphics-thumbnailers
    kdePackages.qtsvg
    kdePackages.kimageformats

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
