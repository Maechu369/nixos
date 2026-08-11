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
    interfaces = {
      "vm-openclaw" = {
        ipv4.addresses = [
          {
            address = "192.168.65.1";
            prefixLength = 24;
          }
        ];
      };
    };
  };
  imports = [
    ./llama
    ./gitea
  ];
}
