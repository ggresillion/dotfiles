{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.profiles.rgb.enable {
    home.packages = [ pkgs.rgb-sync ];

    # Noctalia v5 dropped the v4 "colors.json" live-export file, so watching
    # it with a systemd path unit no longer works - the file simply never
    # gets rewritten anymore. v5's replacement mechanism is its own template
    # engine: register a tiny user template whose post_hook calls rgb-sync
    # directly with the resolved primary color. post_hook is rendered through
    # the same template engine as the file itself, so we don't even need to
    # read the rendered output - the hook command gets the color inline.
    #
    # This fires whenever the palette resolves, including at Noctalia
    # startup. The rendered output file doubles as the persisted color that
    # the system-level openrgb-color service applies at boot (before login)
    # and after resume - keep output_path in sync with that service.
    xdg.configFile."noctalia/templates/rgb-sync.txt".text = ''
      {{ colors.primary_container.default.hex_stripped }}
    '';

    xdg.configFile."noctalia/rgb-sync.toml".text = ''
      [theme.templates.user.rgb_sync]
      input_path  = "$XDG_CONFIG_HOME/noctalia/templates/rgb-sync.txt"
      output_path = "$XDG_STATE_HOME/noctalia/rgb-sync-color.txt"
      post_hook   = "rgb-sync {{ colors.primary_container.default.hex_stripped }}"
    '';
  };
}
