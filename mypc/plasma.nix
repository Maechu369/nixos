{ ... }: {
  networking.firewall = {
    extraInputRules = ''
      iifname "tailscale0" tcp dport 3389 accept
      tcp dport 3389 ip saddr == { 192.168.2.14 } accept
      tcp dport 3389 drop
    '';
  };
}
