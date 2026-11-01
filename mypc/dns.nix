{ ... }:
let
  ip = import ../component/ip.nix;
in
{
  networking.nameservers = [
    ip.zero
  ];
  networking.search = [ ];
}
