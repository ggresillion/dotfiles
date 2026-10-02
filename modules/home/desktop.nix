{
  config,
  pkgs,
  lib,
  ...
}:

let
  vicinaeScript = title: command: {
    executable = true;
    # replaces the copies the old activation script wrote
    force = true;
    text = ''
      #!/usr/bin/env bash
      # @vicinae.schemaVersion 1
      # @vicinae.title ${title}
      # @vicinae.mode silent

      exec ${command}
    '';
  };
in
{
  config = lib.mkIf config.profiles.desktop.enable {
    home.packages = with pkgs; [
      wl-clipboard
      qt6.qttools
    ];

    home.sessionVariables = {
      # Required for Qt/KDE apps (Dolphin, Gwenview, etc.) to use
      # Noctalia's generated dark theme via qt6ct
      QT_QPA_PLATFORMTHEME = "qt6ct";
      # Prefer Wayland, fallback to X11 if unavailable
      GDK_BACKEND = "wayland,x11";
      SDL_VIDEODRIVER = "wayland,x11";
    };

    programs.noctalia = {
      enable = true;
      settings = ./noctalia.toml;
    };

    xdg.configFile =
      builtins.listToAttrs (
        map
          (file: {
            name = "niri/${file}";
            value = {
              source = ./config/niri/${file};
              force = true;
            };
          })
          [
            "config.kdl"
            "binds.kdl"
            "inputs.kdl"
            "outputs.kdl"
            "rules.kdl"
            "settings.kdl"
            "layout.kdl"
          ]
      )
      // {
        "qt6ct/qt6ct.conf".text = ''
          [Appearance]
          style=Fusion
          color_scheme_path=${config.home.homeDirectory}/.config/qt6ct/colors/noctalia.conf
        '';
      };

    # noctalia writes niri/noctalia.kdl at runtime, so it must be a real,
    # writable file rather than a store symlink.
    home.activation.niriNoctalia = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "$HOME/.config/niri"
      touch "$HOME/.config/niri/noctalia.kdl"
      chmod u+w "$HOME/.config/niri" "$HOME/.config/niri/noctalia.kdl"
    '';

    programs.vicinae.enable = true;

    xdg.dataFile = {
      "vicinae/scripts/reboot-uefi.sh" = vicinaeScript "Reboot to UEFI" "reboot-uefi";
      "vicinae/scripts/reboot-windows.sh" = vicinaeScript "Reboot to Windows" "reboot-windows";
    };

    services.linux-wallpaperengine.enable = true;
  };
}
