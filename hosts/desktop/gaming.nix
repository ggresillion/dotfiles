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

  environment.systemPackages = with pkgs; [
    mangohud
    winetricks
    protontricks
    wineWow64Packages.full
  ];

  services.lact.enable = true;
}
