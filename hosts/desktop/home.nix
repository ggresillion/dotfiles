{ pkgs, ... }:

let
  # Vicinae script commands for the reboot helpers in ./reboot.nix.
  vicinaeScript = title: command: {
    executable = true;
    force = true;
    text = ''
      #!/usr/bin/env bash
      # @vicinae.schemaVersion 1
      # @vicinae.title ${title}
      # @vicinae.mode silent

      exec ${command}
    '';
  };
in
{
  imports = [
    ../../modules/home
    ../../modules/home/desktop
    ../../modules/home/apps.nix
    ../../modules/home/extras.nix
    ../../modules/home/gaming.nix
    ../../modules/home/rgb.nix
  ];

  home.packages = [ pkgs.linux-wallpaperengine ];

  xdg.dataFile = {
    "vicinae/scripts/reboot-uefi.sh" = vicinaeScript "Reboot to UEFI" "reboot-uefi";
    "vicinae/scripts/reboot-windows.sh" = vicinaeScript "Reboot to Windows" "reboot-windows";
  };
}
