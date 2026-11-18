{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  cfg = config.profiles.apps;
in
{
  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home.packages = with pkgs; [
        inputs.zen-browser.packages.${stdenv.hostPlatform.system}.default
        yazi
        btop
        fastfetch
        unzip
        p7zip
        unrar
        vlc
        claude-code
        rtk
      ];
    })

    (lib.mkIf cfg.extras.enable {
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

    })
  ];
}
