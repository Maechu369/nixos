{ ip, ... }:
{
  networking.firewall = {
    extraInputRules = ''
      iifname "tailscale0" tcp dport 3389 accept
      tcp dport 3389 ip saddr == { ${ip.arrows} } accept
      tcp dport 3389 drop
    '';
  };
}
