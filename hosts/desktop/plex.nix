{ ... }:
{
  services.plex = {
    enable = true;
    openFirewall = true;
  };

  fileSystems."/mnt/hdd" = {
    device = "/dev/disk/by-label/HDD";
    fsType = "ntfs";
    options = [
      "rw"
      "umask=000"
    ];
  };
}
