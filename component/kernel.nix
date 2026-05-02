{ pkgs, config, ... }: {
  boot.kernelPackages = pkgs.linuxPackages_zen;
  # broken
  # boot.extraModulePackages = with config.boot.kernelPackages; [ rtl8852au ];
}
