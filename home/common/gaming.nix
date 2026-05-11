{ pkgs, ... }:
{
  home.packages = with pkgs; [
    umu-launcher
    godot
    r2modman
    faugus-launcher
    gamescope
    wowup-cf
    # custom proton settings
    steamtinkerlaunch
    xdotool
    xwininfo
    yad
    ###
  ];
}
