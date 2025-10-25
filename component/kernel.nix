{ pkgs, config, ... }: {
  boot.kernelPackages = pkgs.linuxPackages;
  boot.extraModulePackages = with config.boot.kernelPackages; [ rtl8852au ];
}
