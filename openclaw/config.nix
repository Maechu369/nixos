{ ... }:
let
  mac = "02:00:00:00:00:01";
in
{
  networking.hostName = "openclaw";
  systemd.network = {
    enable = true;
    networks."30-lan0" = {
      matchConfig.MACAddress = mac;
      networkConfig = {
        Address = [ "192.168.65.2/24" ];
        Gateway = "192.168.65.1";
        DHCP = "no";
      };
    };
  };
  microvm = {
    interfaces = [
      {
        type = "tap";
        id = "vm-openclaw";
        inherit mac;
      }
    ];
    hypervisor = "qemu";
  };
  system.stateVersion = "26.11";
}
