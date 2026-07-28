{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # quick launcher for exe
    umu-launcher
    # mod manager for valheim
    r2modman
    # generic launcher for non-steam games
    faugus-launcher
    gamescope
    # wow addon manager
    wowup-cf
    # custom proton settings
    steamtinkerlaunch
    xdotool
    xwininfo
    yad
    ###
  ];
}
