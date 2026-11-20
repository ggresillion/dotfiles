{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

# niri + the dux shell (dms), its file manager, search and calendar.
let
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

  # Every file of config/niri, linked one by one: dms writes its own files
  # (dms/*.kdl) next to them.
  niriFiles = lib.mapAttrs' (
    file: _:
    lib.nameValuePair "niri/${file}" {
      source = ../config/niri/${file};
      force = true;
    }
  ) (builtins.readDir ../config/niri);
in
{
  imports = [
    ./keyboard-compose.nix
    ./matugen.nix
    inputs.dux-shell.homeModules.default
    inputs.dux-files.homeModules.default
    inputs.dux-search.homeModules.default
    inputs.dux-calendar.homeModules.default
  ];

  home.packages = with pkgs; [
    wl-clipboard
    qt6.qttools
    papirus-icon-theme
    inputs.dux-gop.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  home.sessionVariables = {
    # Qt apps use the matugen-generated theme through qt6ct
    QT_QPA_PLATFORMTHEME = "qt6ct";
    # Prefer Wayland, fallback to X11 if unavailable
    GDK_BACKEND = "wayland,x11";
    SDL_VIDEODRIVER = "wayland,x11";
  };

  # dms runs as a user service: it never sees home.sessionVariables, and
  # its quickshell has no qt6ct plugin, so tray icons only resolved from
  # hicolor (the rest showed as missing-icon squares). Quickshell takes its
  # icon theme from this variable instead.
  systemd.user.sessionVariables.QS_ICON_THEME = "Papirus-Dark";

  xdg.configFile = niriFiles // {
    # Whole directory points into the repo: dms saves settings.json by
    # replacing it, so a file-level symlink would be clobbered. Changes
    # made in its settings show up in `git diff`.
    "dms" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/modules/home/config/dms";
      force = true;
    };
    # Scheme dms renders into wezterm/colors.
    "wezterm/color-scheme".text = "dank-theme";
    "qt6ct/qt6ct.conf".text = ''
      [Appearance]
      style=Fusion
      icon_theme=Papirus-Dark
      color_scheme_path=${config.home.homeDirectory}/.config/qt6ct/colors/noctalia.conf
    '';
  };

  programs.dank-material-shell = {
    enable = true;
    systemd.enable = true;
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

  # The launcher (Mod+Space) needs its server running.
  programs.vicinae = {
    enable = true;
    systemd.enable = true;
  };

  xdg.dataFile = {
    "vicinae/scripts/reboot-uefi.sh" = vicinaeScript "Reboot to UEFI" "reboot-uefi";
    "vicinae/scripts/reboot-windows.sh" = vicinaeScript "Reboot to Windows" "reboot-windows";
  };
}
