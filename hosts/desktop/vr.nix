{
  pkgs,
  lib,
  ...
}:

{
  services.wivrn = {
    enable = true;
    openFirewall = true;
    package = pkgs.wivrn;
    autoStart = true;
  };

  programs.steam.package = lib.mkDefault (
    pkgs.steam.override (prev: {
      extraEnv = {
        PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES = 1;
      }
      // (prev.extraEnv or { });
    })
  );

  environment.systemPackages = [ pkgs.android-tools ];
}
