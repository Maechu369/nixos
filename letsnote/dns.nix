{ ... }:
let
  ip = import ../component/ip.nix;
in
{
  networking.nameservers = [
    ip.zero
    "1.1.1.1"
    "8.8.8.8"
  ];
}
