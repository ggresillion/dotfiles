{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  # Set to true to re-enable the F6 autoclicker (also uncomment its bind in
  # modules/home/config/niri/binds.kdl).
  enableAutoclicker = false;
in
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
    # SteamOS-like session ("Steam" in the greeter) for HDR: niri has no
    # color management, so HDR only works with gamescope driving the display.
    gamescopeSession = {
      enable = true;
      args = [
        "-W"
        "5120"
        "-H"
        "1440"
        "-r"
        "240"
        "--hdr-enabled"
        "--adaptive-sync"
      ];
    };
  };

  # The Steam library is the @steam subvolume (see ./disko.nix), mounted as
  # root: hand the mountpoint to the user so Steam can write to it.
  systemd.tmpfiles.rules = [
    "d /home/guillaume/.local/share/Steam/steamapps 0755 guillaume users -"
  ];

  # The DMS greeter lists sessions from XDG_DATA_DIRS: expose the session
  # .desktop files (niri, steam) under /run/current-system/sw/share.
  environment.pathsToLink = [ "/share/wayland-sessions" ];

  # Latest kernel instead of the default LTS: the RX 9070 (RDNA4) gets amdgpu
  # fixes and performance improvements with every kernel release.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # ntsync: kernel implementation of Windows sync primitives. Proton (CachyOS,
  # GE, Valve 10+) uses it automatically when /dev/ntsync exists, giving
  # smoother frametimes in CPU-heavy games. Built as a module, not autoloaded.
  boot.kernelModules = [ "ntsync" ];

  # sched_ext scheduler tuned for interactivity: prioritises the game's
  # latency-critical threads over background work (builds, browser, etc.).
  # --performance: no core compaction/power saving, all cores stay ready.
  # Check it is running with `cat /sys/kernel/sched_ext/root/ops`.
  services.scx = {
    enable = true;
    scheduler = "scx_lavd";
    extraArgs = [ "--performance" ];
  };

  # Rebuilds and the weekly GC only use idle CPU/disk time, so a
  # nixos-rebuild running in the background doesn't make games stutter.
  nix.daemonCPUSchedPolicy = "idle";
  nix.daemonIOSchedClass = "idle";

  # Compressed swap in RAM, used before the disk swap partition (higher
  # priority). Swapping to zram is much faster than NVMe, so memory pressure
  # causes small slowdowns instead of freezes. The disk partition stays for
  # hibernation.
  zramSwap.enable = true;
  # Recommended with zram: swapping to RAM is cheap, so the kernel should
  # prefer it over dropping file cache (default 60 is tuned for disk swap).
  boot.kernel.sysctl."vm.swappiness" = 180;

  # Kills the biggest process before RAM is completely full, instead of the
  # whole desktop freezing (systemd-oomd is disabled in modules/nixos/common).
  services.earlyoom.enable = true;

  programs.gamemode = {
    enable = true;
    settings = {
      # Higher CPU priority for the game process (run with `gamemoderun`).
      general.renice = 10;
      # No GPU settings here: LACT manages the RX 9070's performance level
      # (use its per-game profiles), and both writing it would conflict.
    };
  };

  # Managed gamescope wrapper (setuid capabilities for KMS/VT switching),
  # used for per-game HDR: gamescope --hdr-enabled -- %command%
  programs.gamescope.enable = true;

  # Declarative LACT: /etc/lact/config.yaml becomes a read-only symlink, so
  # changes made in the GUI are lost. Tune the values here instead.
  services.lact = {
    enable = true;
    settings =
      let
        gpu = "1002:7550-1458:2424-0000:03:00.0"; # RX 9070 XT
        # OC: the 9070 XT is power-limited, so max power cap + undervolt
        # gives higher sustained clocks. If games crash, raise voltage_offset
        # towards 0 / drop max_memory_clock first.
        oc = {
          fan_control_enabled = false;
          power_cap = 374.0; # max allowed (stock 330)
          performance_level = "manual";
          power_profile_mode_index = 1; # 3D_FULL_SCREEN
          voltage_offset = -50; # mV
          max_memory_clock = 1300; # MHz (stock 1259)
        };
        stock = {
          fan_control_enabled = false;
          power_cap = 330.0;
          performance_level = "auto";
        };
      in
      {
        version = 7;
        daemon = {
          log_level = "info";
          admin_group = "wheel";
          disable_clocks_cleanup = false;
        };
        apply_settings_timer = 5;
        # OC is the default (applied when no profile rule matches).
        gpus.${gpu} = oc;
        profiles = {
          VR = {
            gpus.${gpu} = oc // {
              power_profile_mode_index = 4; # VR
              pmfw_options.zero_rpm = true;
            };
            rule = {
              type = "process";
              filter.name = ".wivrn-server-wrapped";
            };
          };
          # Fallback to rule out the OC when debugging crashes:
          # select it in the LACT GUI (disables auto-switching until reverted).
          Stock.gpus.${gpu} = stock;
        };
        auto_switch_profiles = true;
      };
  };

  # Split-lock detection slows down (or stutters) games doing split locked
  # accesses, common under Proton. SteamOS disables it too.
  boot.kernel.sysctl."kernel.split_lock_mitigate" = 0;

  # Autoclicker: ydotool works on Wayland (niri) via uinput, unlike the
  # X11-only xclicker/xdotool. `autoclick` toggles left-clicking on/off.
  programs.ydotool.enable = enableAutoclicker;
  users.users.guillaume.extraGroups = lib.optionals enableAutoclicker [ "ydotool" ];

  environment.systemPackages =
    with pkgs;
    [
      config.services.displayManager.sessionData.desktops
      mangohud
      winetricks
      protontricks
      wineWow64Packages.full
    ]
    ++ lib.optionals enableAutoclicker [
      (writeShellApplication {
        name = "autoclick";
        runtimeInputs = [
          ydotool
          procps
        ];
        text = ''
          # usage: autoclick [interval_ms]  (run again to stop)
          if pkill -f "ydotool click --repeat"; then exit 0; fi
          exec ydotool click --repeat 1000000 --next-delay "''${1:-50}" 0xC0
        '';
      })
    ];
}
