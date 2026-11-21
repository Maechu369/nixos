{ ... }: {
  services.nginx = {
    enable = true;
  };
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
      allowedTCPPorts = [
        80
        443
      ];
      filterForward = true;
      trustedInterfaces = [
        "ve-*"
        "vm-openclaw"
      ];
      extraForwardRules = ''
        iifname { "vm-openclaw" } oifname { "ve-searxng" } accept
        iifname { "docker0" } accept
      '';
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
    ./gitea
    ./searxng
    ./files
    ./openclaw.nix
  ];
}
