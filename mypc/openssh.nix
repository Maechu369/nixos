{ ... }:
let
  ip = import ../component/ip.nix;
in
{
  imports = [
    ../component/openssh.nix
  ];
  services.openssh = {
    enable = true;
    openFirewall = false;
  };
  networking.firewall.extraInputRules = ''
    ip saddr { ${ip.letsnote}, ${ip.zero} } tcp dport 22 accept
  '';
}
