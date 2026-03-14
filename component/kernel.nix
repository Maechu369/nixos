{ pkgs, config, ... }: {
  boot.kernelPackages = pkgs.linuxPackages;
  # broken
  # boot.extraModulePackages = with config.boot.kernelPackages; [ rtl8852au ];
}
