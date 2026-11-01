{ ip, ... }:
{
  networking.nameservers = [
    ip.zero
  ];
  networking.search = [ ];
}
