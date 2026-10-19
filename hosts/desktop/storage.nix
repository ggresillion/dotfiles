{ ... }:
{
  fileSystems."/mnt/hdd" = {
    device = "/dev/disk/by-label/HDD";
    # ntfs3 is the in-kernel NTFS driver: much faster than ntfs-3g (FUSE).
    # It refuses to mount read-write if Windows left the disk "dirty" (e.g.
    # Fast Startup / hibernation): disable Fast Startup in Windows, or run
    # `sudo ntfsfix -d /dev/disk/by-label/HDD` if the mount fails.
    fsType = "ntfs3";
    options = [
      "rw"
      "uid=1000"
      "gid=100"
      "umask=022"
      "nofail"
    ];
  };
  programs.fuse.userAllowOther = true;
}
