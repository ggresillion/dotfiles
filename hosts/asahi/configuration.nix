{ lib, pkgs, ... }:

{
  networking.hostName = "guillaume-asahi";

  hardware.asahi.enable = true;

  # m1n1 + U-Boot expose a bare UEFI: no Secure Boot and no writable EFI
  # variables, so limine's secure boot setup from common can't apply.
  boot.loader.limine.enable = lib.mkForce false;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

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
