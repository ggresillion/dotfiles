{
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
    // { };

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
}
