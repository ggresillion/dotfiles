{ pkgs, ... }:

# Extra apps: chat, torrents, media, monitoring.
{
  home.packages = with pkgs; [
    vesktop
    gocryptfs
    nvtopPackages.amd
    tor-browser
    qbittorrent
    caprine
    opencode
    amdgpu_top
    mpvpaper
    ncdu
    file
    deezer-tui
    websocat
  ];

  xdg.configFile."opencode/opencode.jsonc" = {
    source = ./config/opencode/opencode.jsonc;
    force = true;
  };
}
