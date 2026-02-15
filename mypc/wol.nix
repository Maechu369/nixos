{ ... }: {
  networking = {
    interfaces = {
      enp5s0 = {
        wakeOnLan = {
          enable = true;
          policy = [ "magic" ];
        };
      };
    };
    firewall = { allowedUDPPorts = [ 9 ]; };
  };
}

