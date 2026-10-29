{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.profiles.rgb.enable {
    home.packages = [ pkgs.rgb ];

    # Noctalia renders this on every palette change; the output file is the
    # color used by `rgb` in auto mode (also at boot, before login).
    xdg.configFile."noctalia/templates/rgb.txt".text = ''
      {{ colors.primary_container.default.hex_stripped }}
    '';
    xdg.configFile."noctalia/rgb.toml".text = ''
      [theme.templates.user.rgb]
      input_path  = "$XDG_CONFIG_HOME/noctalia/templates/rgb.txt"
      output_path = "$XDG_STATE_HOME/rgb-color"
      post_hook   = "rgb palette {{ colors.primary_container.default.hex_stripped }}"
    '';
    # Same template for dms (see matugen.nix).
    matugen.templates.rgb = {
      input_path = "${config.xdg.configHome}/noctalia/templates/rgb.txt";
      output_path = "${config.xdg.stateHome}/rgb-color";
      post_hook = "rgb palette {{ colors.primary_container.default.hex_stripped }}";
    };
  };
}
