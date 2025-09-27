{
  fileSystems."/mnt/c" = {
    device = "/dev/disk/by-uuid/6CE4E756E4E72156";
    fsType = "ntfs";
    options = [ "fmask=0022" "dmask=0022" ];
  };

  fileSystems."/mnt/d" = {
    device = "/dev/disk/by-uuid/C2440DAC440DA46F";
    fsType = "ntfs";
    options = [ "fmask=0022" "dmask=0022" ];
  };

  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 32 * 1024; # MB
  }];

  zramSwap = {
    enable = true;
    priority = 5;
    algorithm = "zstd";
    memoryPercent = 25;
  };
  boot.tmp.useTmpfs = true;
}
