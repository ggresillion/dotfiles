{ pkgs, inputs, ... }:

{
  # Disabled until fixed
  # https://github.com/SteamClientHomebrew/Millennium/issues/551
  # nixpkgs.overlays = [ inputs.millennium.overlays.default ];

  programs.steam = {
    enable = true;
    # package = pkgs.millennium-steam;
    gamescopeSession.enable = true;
  };

  programs.gamemode.enable = true;

  environment.systemPackages = with pkgs; [
    mangohud
  ];
}
