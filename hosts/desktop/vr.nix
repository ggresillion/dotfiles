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

  environment.systemPackages = with pkgs; [
    opencomposite
    xrizer
  ];

  programs.steam.package = lib.mkDefault (
    pkgs.steam.override (prev: {
      extraEnv = {
        PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES = 1;
      }
      // (prev.extraEnv or { });
    })
  );
}
