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
        kdePackages.gwenview
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

      # Mic chain for Discord (Vesktop): select "Easy Effects Source" as the
      # input device there, keep Krisp on and automatic gain control off.
      services.easyeffects = {
        enable = true;
        preset.input = "discord-voice";
        extraPresets.discord-voice.input = {
          blocklist = [ ];
          plugins_order = [
            "filter#0"
            "equalizer#0"
            "compressor#0"
            "limiter#0"
          ];
          # Cut rumble below 90 Hz
          "filter#0" = {
            bypass = false;
            type = "High-pass";
            frequency = 90.0;
            slope = "x2";
          };
          # Less mud, more presence
          "equalizer#0" =
            let
              bands = {
                band0 = {
                  type = "Bell";
                  frequency = 300.0;
                  gain = -2.0;
                  q = 1.0;
                };
                band1 = {
                  type = "Bell";
                  frequency = 4000.0;
                  gain = 2.5;
                  q = 0.9;
                };
              };
            in
            {
              bypass = false;
              num-bands = 2;
              split-channels = false;
              mode = "IIR";
              left = bands;
              right = bands;
            };
          "compressor#0" = {
            bypass = false;
            mode = "Downward";
            threshold = -20.0;
            ratio = 3.5;
            attack = 8.0;
            release = 100.0;
            knee = -6.0;
            makeup = 6.0;
            sidechain = {
              type = "Feed-forward";
              mode = "RMS";
            };
          };
          "limiter#0" = {
            bypass = false;
            threshold = -1.0;
            lookahead = 5.0;
            release = 20.0;
          };
        };
      };
    })
  ];
}
