{
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
  };

  # Latest kernel instead of the default LTS: the RX 9070 (RDNA4) gets amdgpu
  # fixes and performance improvements with every kernel release.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # ntsync: kernel implementation of Windows sync primitives. Proton (CachyOS,
  # GE, Valve 10+) uses it automatically when /dev/ntsync exists, giving
  # smoother frametimes in CPU-heavy games. Built as a module, not autoloaded.
  boot.kernelModules = [ "ntsync" ];

  # sched_ext scheduler tuned for interactivity: prioritises the game's
  # latency-critical threads over background work (builds, browser, etc.).
  # Check it is running with `scxctl get`.
  services.scx = {
    enable = true;
    scheduler = "scx_lavd";
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
      gpu = {
        # Required for gamemode to touch GPU settings at all.
        apply_gpu_optimisations = "accept-responsibility";
        # /dev/dri/card1 is the RX 9070 (card0 is the iGPU).
        gpu_device = 1;
        # Keep GPU clocks high while gaming, avoiding clock ramp-up stutter.
        amd_performance_level = "high";
      };
    };
  };

  # Managed gamescope wrapper (setuid capabilities for KMS/VT switching),
  # used for per-game HDR: gamescope --hdr-enabled -- %command%
  programs.gamescope.enable = true;

  services.lact.enable = true;

  # Autoclicker: ydotool works on Wayland (niri) via uinput, unlike the
  # X11-only xclicker/xdotool. `autoclick` toggles left-clicking on/off.
  programs.ydotool.enable = enableAutoclicker;
  users.users.guillaume.extraGroups = lib.optionals enableAutoclicker [ "ydotool" ];

  environment.systemPackages =
    with pkgs;
    [
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
