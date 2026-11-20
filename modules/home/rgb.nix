{ config, pkgs, ... }:

# OpenRGB color follows the dms palette. matugen renders the color on every
# palette change; `rgb` reads it in auto mode (also at boot, before login).
{
  home.packages = [ pkgs.rgb ];

  matugen.templates.rgb = {
    input_path = "${pkgs.writeText "rgb.txt" ''
      {{ colors.primary_container.default.hex_stripped }}
    ''}";
    output_path = "${config.xdg.stateHome}/rgb-color";
    post_hook = "rgb palette {{ colors.primary_container.default.hex_stripped }}";
  };
}
