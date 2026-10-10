{ ... }:
{
  imports = [
    ../component/openssh.nix
  ];
  services.openssh = {
    enable = true;
    openFirewall = false;
  };
  networking.firewall.extraInputRules = ''
    ip saddr { 192.168.2.13 } tcp dport 22 accept
  '';
}
