{
  pkgs,
  ...
}:

let
  rgb-sync = pkgs.writeShellApplication {
    name = "rgb-sync";
    runtimeInputs = [
      pkgs.jq
      pkgs.openrgb
    ];
    text = ''
      COLORS_FILE="$HOME/.config/noctalia/colors.json"

      if [[ ! -f "$COLORS_FILE" ]]; then
        echo "colors.json not found at $COLORS_FILE" >&2
        exit 0
      fi

      hex=$(jq -r '.mPrimary' "$COLORS_FILE")
      hex=''${hex#\#}

      echo "Applying primary color #$hex to all OpenRGB devices"
      openrgb --mode static --color "$hex"
    '';
  };
in
{
  home.packages = [ rgb-sync ];

  # Triggered whenever colors.json is written
  systemd.user.services.rgb-sync = {
    Unit.Description = "Apply Noctalia primary color to OpenRGB devices";
    Service = {
      Type = "oneshot";
      ExecStart = "${rgb-sync}/bin/rgb-sync";
    };
  };

  systemd.user.paths.rgb-sync = {
    Unit.Description = "Watch noctalia colors.json for changes";
    Path.PathModified = "%h/.config/noctalia/colors.json";
    Install.WantedBy = [ "paths.target" ];
  };

  # Run once at session start too
  systemd.user.services.rgb-sync-startup = {
    Unit = {
      Description = "Apply RGB color at session start";
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${rgb-sync}/bin/rgb-sync";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
