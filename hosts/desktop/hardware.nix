{
  config,
  lib,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];
  boot.initrd.availableKernelModules = [
    "nvme"
    "ahci"
    "xhci_pci"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [
    "kvm-amd"
    "nct6687"
  ];

  # nct6687d: out-of-tree driver for the Nuvoton NCT6687-R Super I/O chip on
  # this MSI B850 Tomahawk (fan RPM/PWM, voltages, temps). The in-tree
  # nct6683 driver doesn't support this chip's fan-curve register layout on
  # MSI B850/X870/Z890 boards, so we use nct6687d instead. Note: the 0db0:0076
  # USB device (Mystic Light) is a separate RGB controller, unrelated to this.
  boot.extraModulePackages = [ config.boot.kernelPackages.nct6687d ];

  boot.kernelParams = [
    # Required or the driver fails to bind: ACPI reserves the chip's I/O
    # port range, causing "resource conflict" / "EC base I/O port
    # unconfigured" errors on load without this.
    "acpi_enforce_resources=lax"
    # System fans (SYS_FAN, pwm index >= 2) on this board only respond to
    # fan-curve register writes, not direct PWM writes. This makes the
    # driver write the target value to all 7 curve points so the EC
    # actually applies it. CPU/pump fan are unaffected.
    "nct6687.msi_fan_brute_force=1"
  ];

  # Ensure nct6687 loads after i2c_i801 (recommended by upstream to avoid
  # load-order issues where the SIO device isn't ready yet).
  boot.extraModprobeConfig = ''
    softdep nct6687 pre: i2c_i801
  '';

  # Blacklist the in-tree nct6683 driver so it can't grab the device first
  boot.blacklistedKernelModules = [ "nct6683" ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
