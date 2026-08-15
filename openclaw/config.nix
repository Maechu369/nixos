{ pkgs, ... }:
let
  mac = "02:00:00:00:00:01";
in
{
  networking.hostName = "openclaw";
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.config.permittedInsecurePackages = [
  ];
  environment.systemPackages = with pkgs; [
    zeroclaw
  ];
  users.users."root" = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFbkbVhapmW864se06Wk+IWzm5XmfsP0nohg0MVX9b1i openpgp:0x67DC50BF"
    ];
  };
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
    writableStoreOverlay = "/var/lib/volumes/openclaw/nix-store.img";
    volumes = [
      {
        autoCreate = true;
        mountPoint = "/var/lib";
        image = "/var/lib/volumes/openclaw/var-lib.img";
        size = 1024;
      }
    ];
    interfaces = [
      {
        type = "tap";
        id = "vm-openclaw";
        inherit mac;
      }
    ];
    hypervisor = "qemu";
  };
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
  };
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "yes";
    };
    hostKeys = [
      {
        path = "/var/lib/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };
  system.stateVersion = "26.11";
}
