{ ... }: {
  networking = {
    nat = {
      enable = true;
      internalInterfaces = [
        "ve-*"
        "vm-openclaw"
      ];
      externalInterface = "enp5s0";
      enableIPv6 = false;
    };
    firewall = {
      filterForward = true;
      trustedInterfaces = [
        "ve-*"
        "vm-openclaw"
      ];
    };
  };
  systemd.network = {
    enable = true;
    networks = {
      "vm-openclaw" = {
        matchConfig.Name = "vm-openclaw";
        networkConfig = {
          Address = [ "192.168.65.1/24" ];
          DHCP = "no";
        };
      };
    };
  };
  imports = [
    ./llama
    ./gitea
  ];
}
