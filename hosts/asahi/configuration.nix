{ lib, pkgs, ... }:

{
  networking.hostName = "guillaume-asahi";

  hardware.asahi.enable = true;

  # Faster first install: no source-built HDR sessions or wallpaper engine.
  # Turn off once the base system boots.
  desktop.lite = true;

  # m1n1 + U-Boot expose a bare UEFI: no Secure Boot and no writable EFI
  # variables, so limine's secure boot setup from common can't apply.
  # Aurora's module boots through GRUB (removable EFI path).
  boot.loader.limine.enable = lib.mkForce false;
  # The 476 MB ESP holds every listed generation's kernel and initrd.
  boot.loader.grub.configurationLimit = 3;

  # Root is ext4, so there is no @home btrfs subvolume to snapshot.
  services.btrbk.instances = lib.mkForce { };

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
