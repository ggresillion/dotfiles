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
  boot.kernelModules = [ "kvm-amd" "nct6687" ];
  # nct6687d: out-of-tree kernel module for the Nuvoton NCT6687-R chip on this
  # MSI B850 Tomahawk. Fan/PWM control is not exposed via standard hwmon sysfs
  # because the chip lives behind an internal USB HID device (MYSTIC LIGHT,
  # 0db0:0076) that the kernel's built-in drivers don't bind to.
  boot.extraModulePackages = [ config.boot.kernelPackages.nct6687d ];
  # Prevent ACPI from claiming the I/O regions the driver needs
  boot.kernelParams = [ "acpi_enforce_resources=lax" ];
  # Blacklist the in-tree nct6683 driver so nct6687d can bind instead
  boot.blacklistedKernelModules = [ "nct6683" ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
