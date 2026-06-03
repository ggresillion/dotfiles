{ pkgs, ... }:
let
  colorFile = "/home/guillaume/.config/noctalia/colors.json";

  rgb-apply = pkgs.writeScriptBin "rgb-apply" ''
    #!/bin/sh
    if [ -f "${colorFile}" ]; then
      COLOR=$(${pkgs.jq}/bin/jq -r '.mOnPrimary' "${colorFile}" | tr -d '#')
    else
      COLOR="000000"
    fi

    # Fire all devices in parallel
    for i in 0 1 2; do
      ${pkgs.openrgb}/bin/openrgb --device $i --mode static --color "$COLOR" &
    done
    wait
  '';

  rgb-watch = pkgs.writeScriptBin "rgb-watch" ''
    #!/bin/sh
    ${rgb-apply}/bin/rgb-apply
    while ${pkgs.inotify-tools}/bin/inotifywait -e close_write "${colorFile}"; do
      ${rgb-apply}/bin/rgb-apply
    done
  '';
in
{
  services.hardware.openrgb = {
    enable = true;
    motherboard = "intel";
  };
  boot.kernelModules = [ "i2c-dev" ];
  hardware.i2c.enable = true;

  environment.systemPackages = [
    pkgs.jq
    pkgs.inotify-tools
    rgb-apply
    rgb-watch
  ];

  systemd.services.rgb-apply = {
    description = "Apply RGB color from Noctalia theme";
    after = [ "openrgb.service" ];
    requires = [ "openrgb.service" ];
    serviceConfig = {
      ExecStart = "${rgb-apply}/bin/rgb-apply";
      Type = "oneshot";
      RemainAfterExit = true;
      User = "guillaume";
    };
    wantedBy = [ "multi-user.target" ];
  };

  systemd.user.services.rgb-watch = {
    description = "Watch Noctalia colors and sync to RGB";
    after = [ "openrgb.service" ];
    serviceConfig = {
      ExecStart = "${rgb-watch}/bin/rgb-watch";
      Restart = "always";
      RestartSec = "3";
    };
    wantedBy = [ "default.target" ];
  };
}
