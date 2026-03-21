{ ... }: {
  swapDevices = [{
    device = "/dev/vg/swap";
  }];

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

