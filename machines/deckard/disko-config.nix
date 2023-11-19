{ disks, ... }: {
  disko.devices = {
    disk = {
      sda = {
        type = "disk";
        device = builtins.elemAt disks 0;
        content = {
          type = "table";
          format = "gpt";
          partitions = [
            {
              name = "ESP";
              start = "1M";
              end = "500M";
              bootable = true;
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            }
            {
              name = "root";
              start = "500M";
              end = "-32G";
              part-type = "primary";
              bootable = true;
              content = {
                type = "zfs";
                pool = "rpool1";
              };
            }
            {
              name = "swap";
              start = "-32G";
              end = "100%";
              content = {
                type = "swap";
                randomEncryption = false;
              };
            }
          ];
        };
      };
    };
    zpool = {
      rpool1 = {
        type = "zpool";

        rootFsOptions = {
          compression = "lz4";
          "com.sun:auto-snapshot" = "false";
          canmount = "off";
          xattr = "sa";
          atime = "off";
        };
        options = {
          ashift = "12";
          autotrim = "on";
        };
        datasets = {
          zroot = {
            type = "zfs_fs";
            mountpoint = "/";
            postCreateHook = "zfs snapshot rpool1/zroot@blank";
            options = {
              mountpoint = "legacy";
            };
          };
          znix = {
            type = "zfs_fs";
            mountpoint = "/nix";
            options = {
              mountpoint = "legacy";
            };
          };
          zvar = {
            type = "zfs_fs";
            mountpoint = "/var";
            options = {
              mountpoint = "legacy";
            };
          };
        };
      };
    };
  };
}

