{
  config,
  pkgs,
  lib,
  inputs,
  osConfig,
  ...
}:

let
  # Set in modules/nixos/desktop/niri.nix
  shell = osConfig.desktop.shell or "noctalia";

  # Shared by dms, dux-files and dank-calendar so home.packages gets a single
  # quickshell; exposes QtWebSockets to its QML import path
  quickshell = pkgs.quickshell.overrideAttrs (old: {
    buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.qt6.qtwebsockets ];
  });

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
  imports = [
    inputs.dux-shell.homeModules.default
    inputs.dux-files.homeModules.default
    inputs.dux-search.homeModules.default
    inputs.dux-calendar.homeModules.default
  ];

  config = lib.mkIf config.profiles.desktop.enable {
    home.packages = with pkgs; [
      wl-clipboard
      qt6.qttools
      linux-wallpaperengine
      inputs.dux-gop.packages.${pkgs.stdenv.hostPlatform.system}.default
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
        # Shell-specific autostart, binds and colors.
        "niri/shell.kdl" = {
          source = ./config/niri/shell-${shell}.kdl;
          force = true;
        };
        # Whole directory points into the repo: dms saves settings.json by
        # replacing it, so a file-level symlink would be clobbered. Changes
        # made in its settings show up in `git diff`.
        "dms" = {
          source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/modules/home/config/dms";
          force = true;
        };
        # Scheme each shell renders into wezterm/colors.
        "wezterm/color-scheme".text = if shell == "dux" then "dank-theme" else "Noctalia";
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

    # Both shells are installed; only the one picked by desktop.shell starts
    # (noctalia from niri, dms from its systemd service).
    programs.dank-material-shell = {
      enable = true;
      systemd.enable = shell == "dux";
      # khal fails to build on current nixpkgs
      enableCalendarEvents = false;
      quickshell.package = quickshell;
    };

    programs.dux-files = {
      enable = true;
      quickshell.package = quickshell;
    };
    programs.dsearch.enable = true;
    programs.dank-calendar = {
      enable = true;
      quickshell.package = quickshell;
    };

    programs.vicinae.enable = true;

    xdg.dataFile = {
      "vicinae/scripts/reboot-uefi.sh" = vicinaeScript "Reboot to UEFI" "reboot-uefi";
      "vicinae/scripts/reboot-windows.sh" = vicinaeScript "Reboot to Windows" "reboot-windows";
    };
  };
}
