{ ... }:
{
  fileSystems."/mnt/hdd" = {
    device = "/dev/disk/by-label/HDD";
    fsType = "ntfs-3g";
    options = [
      "rw"
      "uid=1000"
      "gid=100"
      "umask=000"
      "nofail"
    ];
  };
  programs.fuse.userAllowOther = true;
}
