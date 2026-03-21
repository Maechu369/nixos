{ ... }: {
  zramSwap = {
    enable = true;
    priority = 5;
    algorithm = "zstd";
    memoryPercent = 25;
  };
  boot.tmp.useTmpfs = true;

  # swapのあるデバイス
  #boot.resumeDevice = "/dev/disk/by-uuid/f7e01cc4-f1af-47ce-bb2b-14cd7bbd26ac";
  # swapfileのoffsetの先頭(swapfileのみ)
  # sudo filefrag -v /path/to/swapfile | head -n 4
  #boot.kernelParams = [ "resume_offset=427436032" ];
}

