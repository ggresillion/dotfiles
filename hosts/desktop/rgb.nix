{ config, pkgs, ... }:

# OpenRGB server, plus the `rgb` mode (pkgs/rgb) applied on start and resume.
{
  # openrgb-git: nixpkgs' openrgb lacks this MSI B850 board's i2c devices.
  services.hardware.openrgb = {
    enable = true;
    package = pkgs.openrgb-git;
    motherboard = "amd";
  };
  # Let the devices appear before the server scans them.
  systemd.services.openrgb.serviceConfig.ExecStartPre =
    "${pkgs.systemd}/bin/udevadm settle --timeout=30";

  # Apply the RGB mode (pkgs/rgb) whenever the server starts and after resume.
  systemd.services.rgb =
    let
      sleepTargets = [
        "suspend.target"
        "hibernate.target"
        "hybrid-sleep.target"
        "suspend-then-hibernate.target"
      ];
    in
    {
      after = [ "openrgb.service" ] ++ sleepTargets;
      requires = [ "openrgb.service" ];
      wantedBy = [ "openrgb.service" ] ++ sleepTargets;
      environment = {
        XDG_CONFIG_HOME = "/run/rgb";
        XDG_STATE_HOME = "${config.users.users.guillaume.home}/.local/state";
      };
      serviceConfig = {
        Type = "oneshot";
        RuntimeDirectory = "rgb";
        ExecStart = "${pkgs.lib.getExe pkgs.rgb} apply --wait";
      };
    };

  # The server only detects devices at startup: restart it on keyboard replug.
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="0e20", RUN+="${pkgs.systemd}/bin/systemctl --no-block try-restart openrgb.service"
  '';
}
