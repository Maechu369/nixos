{ ... }: {
  networking = {
    nat = {
      enable = true;
      internalInterfaces = [ "ve-*" ];
      externalInterface = "enp5s0";
      enableIPv6 = false;
    };
    firewall = {
      filterForward = true;
      trustedInterfaces = [ "ve-*" ];
    };
  };
  imports = [
    ./llama
    ./gitea
  ];
}
