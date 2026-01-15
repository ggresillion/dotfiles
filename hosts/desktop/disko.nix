{
  disko.devices = {
    disk.main = {
      type = "disk";
      device = "/dev/sdX";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            size = "128M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };

          root = {
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ];
              subvolumes = {
                "@root" = {
                  mountpoint = "/";
                  mountOptions = [ "compress=zstd" ];
                };

                "@home" = {
                  mountpoint = "/home";
                  mountOptions = [ "compress=zstd" ];
                };

                "@nix" = {
                  mountpoint = "/nix";
                  mountOptions = [ "compress=zstd" "noatime" ];
                };
              };
            };
          };
        };
      };
    };
  };
}
