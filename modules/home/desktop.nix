{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    inputs.noctalia.homeModules.default
  ];

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

  home.activation.cleanNiriConfig = lib.hm.dag.entryBefore [ "writeBoundary" ] ''
    if [ -L "$HOME/.config/niri" ]; then
      rm "$HOME/.config/niri"
    fi
  '';

  home.activation.niriNoctalia = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "$HOME/.config/niri"
    touch "$HOME/.config/niri/noctalia.kdl"
    chmod u+w "$HOME/.config/niri" "$HOME/.config/niri/noctalia.kdl"
  '';

  programs.vicinae.enable = true;

  home.activation.vicinaeScripts = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "$HOME/.local/share/vicinae/scripts"

    cat > "$HOME/.local/share/vicinae/scripts/reboot-uefi.sh" << 'EOF'
#!/usr/bin/env bash
# @vicinae.schemaVersion 1
# @vicinae.title Reboot to UEFI
# @vicinae.mode silent

exec reboot-uefi
EOF

    cat > "$HOME/.local/share/vicinae/scripts/reboot-windows.sh" << 'EOF'
#!/usr/bin/env bash
# @vicinae.schemaVersion 1
# @vicinae.title Reboot to Windows
# @vicinae.mode silent

exec reboot-windows
EOF

    chmod +x "$HOME/.local/share/vicinae/scripts/reboot-uefi.sh" \
           "$HOME/.local/share/vicinae/scripts/reboot-windows.sh"
  '';
}
