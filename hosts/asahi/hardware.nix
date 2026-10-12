{ lib, ... }:

# Partitions are created by the Asahi installer next to macOS, so no disko
# here: it would wipe the macOS container. Replace the ESP UUID with the one
# from `nixos-generate-config --root /mnt` at install time.
{
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/0000-0000";
    fsType = "vfat";
    options = [ "umask=0077" ];
  };
}
