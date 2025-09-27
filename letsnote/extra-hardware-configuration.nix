{
  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 9 * 1024; # MB
  }];

  zramSwap = {
    enable = true;
    priority = 5;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  boot.tmp.useTmpfs = true;
}

