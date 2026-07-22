{ pkgs, ... }:
let
  rgb-sync = pkgs.writeShellApplication {
    name = "rgb-sync";
    runtimeInputs = [ pkgs.openrgb ];
    text = ''
      hex="''${1:?usage: rgb-sync <hex> (no leading #)}"
      hex="''${hex#\#}"
      echo "Applying primary color #$hex to all OpenRGB devices"
      openrgb --mode static --color "$hex"
    '';
  };
in
{
  home.packages = [ rgb-sync ];

  # Noctalia v5 dropped the v4 "colors.json" live-export file, so watching
  # it with a systemd path unit no longer works - the file simply never
  # gets rewritten anymore. v5's replacement mechanism is its own template
  # engine: register a tiny user template whose post_hook calls rgb-sync
  # directly with the resolved primary color. post_hook is rendered through
  # the same template engine as the file itself, so we don't even need to
  # read the rendered output - the hook command gets the color inline.
  #
  # This fires whenever the palette resolves, including at Noctalia
  # startup, so it also replaces the old "apply once at session start"
  # oneshot service - no extra systemd units needed at all.
  xdg.configFile."noctalia/templates/rgb-sync.txt".text = ''
    {{ colors.primary_container.default.hex_stripped }}
  '';

  xdg.configFile."noctalia/rgb-sync.toml".text = ''
    [theme.templates.user.rgb_sync]
    input_path  = "$XDG_CONFIG_HOME/noctalia/templates/rgb-sync.txt"
    output_path = "$XDG_STATE_HOME/noctalia/rgb-sync-color.txt"
    post_hook   = "rgb-sync {{ colors.primary_container.default.hex_stripped }}"
  '';
}
