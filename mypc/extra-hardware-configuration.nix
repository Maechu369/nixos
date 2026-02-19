{ ... }: {
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

  # swapのあるデバイス
  boot.resumeDevice = "/dev/disk/by-uuid/f7e01cc4-f1af-47ce-bb2b-14cd7bbd26ac";
  # swapfileのoffsetの先頭(swapfileのみ)
  # sudo filefrag -v /path/to/swapfile | head -n 4
  boot.kernelParams = [ "resume_offset=427436032" ];
}

