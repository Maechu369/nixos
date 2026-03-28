{ username, ... }:
{
  boot.supportedFilesystems = [ "zfs" ];
  networking.hostId = "abcd1234";

  fileSystems."/nix" = {
    device = "tank/nix";
    fsType = "zfs";
  };
  boot.zfs.forceImportRoot = false;
  boot.zfs.forceImportAll = false;

  fileSystems."/home/${username}/.local/share/Steam" = {
    device = "tank/steam";
    fsType = "zfs";
    noCheck = true;
  };

  swapDevices = [
    {
      device = "/dev/vg/swap";
    }
  ];

  zramSwap = {
    enable = true;
    priority = 5;
    algorithm = "zstd";
    memoryPercent = 25;
  };
  boot.tmp.useTmpfs = true;

  # swapのあるデバイス
  boot.resumeDevice = "/dev/vg/swap";
}
