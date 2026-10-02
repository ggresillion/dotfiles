{ ... }:

{
  # Hourly local btrfs snapshots of /home (the @home subvolume). These protect
  # against accidental deletion, not disk failure: they live on the same disk.
  # Restore with: cp -a /home/.snapshots/home.<timestamp>/<path> ~/<path>
  services.btrbk.instances.home = {
    onCalendar = "hourly";
    settings = {
      snapshot_preserve_min = "6h";
      snapshot_preserve = "48h 14d 4w";
      snapshot_dir = "/home/.snapshots";
      subvolume."/home" = { };
    };
  };

  systemd.tmpfiles.rules = [ "d /home/.snapshots 0755 root root -" ];
}
