{
  inputs,
  pkgs,
  ...
}:

{
  # Disabled until fixed
  # https://github.com/SteamClientHomebrew/Millennium/issues/551
  nixpkgs.overlays = [ inputs.millennium.overlays.default ];

  programs.steam = {
    enable = true;
    package = pkgs.millennium-steam;
    remotePlay.openFirewall = true;
  };

  programs.gamemode.enable = true;

  environment.systemPackages = with pkgs; [
    mangohud
    winetricks
    protontricks
    wineWow64Packages.full
  ];

  services.lact.enable = true;
}
