{
  config,
  lib,
  pkgs,
  ...
}:

{
  networking.hostName = "guillaume-asahi";

  hardware.asahi.enable = true;

  # Workaround 3 (see default.nix): the J504 panel runs at 120 Hz but its
  # swaps go out unstamped, which the 14.7 DCP firmware completes at 60 fps.
  # aurora-silicon/linux#1632 stamps the other 120 Hz M3 panels; the J504
  # record (linux#2147) missed it.
  # Remove when upstream's J504 record sets swap_timestamps (the patch then
  # fails to apply); drop this whole boot.kernelPackages override with it.
  # Passed to the Asahi kernel directly: through boot.kernelPatches it would
  # be applied twice (nixos-apple-silicon forwards them and NixOS adds them).
  boot.kernelPackages = lib.mkForce (
    config.hardware.asahi.pkgs.linux-asahi.override {
      _kernelPatches = config.boot.kernelPatches ++ [
        {
          name = "j504-swap-timestamps";
          patch = ./patches/j504-swap-timestamps.patch;
        }
      ];
    }
  );

  # Faster first install: no source-built HDR sessions or wallpaper engine.
  # Turn off once the base system boots.
  desktop.lite = true;

  # m1n1 + U-Boot expose a bare UEFI: no Secure Boot and no writable EFI
  # variables, so limine's secure boot setup from common can't apply.
  # Aurora's module boots through GRUB (removable EFI path).
  boot.loader.limine.enable = lib.mkForce false;
  # The 476 MB ESP holds every listed generation's kernel and initrd.
  boot.loader.grub.configurationLimit = 3;

  # Experiment (2026-11-18): Aurora caps the M3 GPU at performance state 2
  # (618 MHz) of 8 until its power management is validated; the driver
  # accepts 1 to 5. Frequencies and voltages still come from Apple's table,
  # and the driver's thermal limit still drops back to state 2 at 88 C.
  # State 5 = 1056 MHz; M3 Airs run it daily and state 8 passed an hour of
  # mixed load on a J613 (omacom/linux-aurora#164). Watch temperatures
  # under sustained 3D load: between caps 3 and 5 a GPU kept busy can stop
  # the thermal limit from stepping down (omacom/linux-aurora#500).
  # Risk: GPU firmware hangs (reboot needed) or resets under heavy load.
  # Remove if the GPU hangs, or once upstream raises the default.
  # The GPU driver is the aurora module (loaded after switch-root) and the
  # parameter is named asahi.t8122_pstate_cap. As a boot option, neither
  # asahi.* (wrong module) nor aurora.asahi.* (kmod drops dotted names)
  # reaches it, so it goes through modprobe.d.
  boot.extraModprobeConfig = ''
    options aurora asahi.t8122_pstate_cap=5
  '';

  hardware.xpadneo.enable = lib.mkForce false;

  services.power-profiles-daemon.enable = true;
  zramSwap.enable = true;

  environment.systemPackages = with pkgs; [
    git
    wget
    vim
  ];

  system.stateVersion = "26.05";
}
