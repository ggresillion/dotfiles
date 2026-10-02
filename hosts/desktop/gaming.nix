{
  inputs,
  pkgs,
  ...
}:

{
  nixpkgs.overlays = [ inputs.millennium.overlays.default ];

  programs.steam = {
    enable = true;
    package = pkgs.millennium-steam.override {
      # Let pressure-vessel (Proton's container) see the host's OpenXR
      # runtime (WiVRn, see ./vr.nix).
      extraEnv.PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES = 1;
    };
    remotePlay.openFirewall = true;
  };

  programs.gamemode.enable = true;

  # Managed gamescope wrapper (setuid capabilities for KMS/VT switching),
  # used for per-game HDR: gamescope --hdr-enabled -- %command%
  programs.gamescope.enable = true;

  services.lact.enable = true;

  # Autoclicker: ydotool works on Wayland (niri) via uinput, unlike the
  # X11-only xclicker/xdotool. `autoclick` toggles left-clicking on/off.
  programs.ydotool.enable = true;
  users.users.guillaume.extraGroups = [ "ydotool" ];

  environment.systemPackages = with pkgs; [
    mangohud
    winetricks
    protontricks
    wineWow64Packages.full
    (writeShellApplication {
      name = "autoclick";
      runtimeInputs = [
        ydotool
        procps
      ];
      text = ''
        # usage: autoclick [interval_ms]  (run again to stop)
        if pkill -f "ydotool click --repeat"; then exit 0; fi
        exec ydotool click --repeat 1000000 --next-delay "''${1:-50}" 0xC0
      '';
    })
  ];
}
