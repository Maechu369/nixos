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
  boot.kernelModules = [ "overlay" ];
  microvm = {
    writableStoreOverlay = "/var/lib/volumes/openclaw/nix-store.img";
    volumes = [
      {
        autoCreate = true;
        mountPoint = "/var/tmp";
        image = "/var/lib/volumes/openclaw/var-tmp.img";
        size = 1024;
      }
      {
        autoCreate = true;
        mountPoint = "/var/lib";
        image = "/var/lib/volumes/openclaw/var-lib.img";
        size = 8192;
      }
    ];
    interfaces = [
      {
        type = "tap";
        id = "vm-openclaw";
        inherit mac;
      }
    ];
    mem = 1024;
    hypervisor = "qemu";
  };
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      22
      18789
    ];
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
  virtualisation.podman.enable = true;
  virtualisation.podman.dockerCompat = true;
  virtualisation.oci-containers = {
    backend = "podman";
    containers."openclaw" = {
      image = "ghcr.io/openclaw/openclaw:2026.6.10-beta.1-browser";
      autoStart = true;
      user = "1000:1000";
      networks = [ "host" ];
      environment = {
        OPENCLAW_TZ = "Asia/Tokyo";
      };
      extraOptions = [
        "--health-cmd=curl -fsS http://127.0.0.1:18789/healthz || exit 1"
        "--health-interval=30s"
        "--security-opt=no-new-privileges"
      ];
      # 手動で下記のディレクトリを生成し、chown 1000:1000すること
      volumes = [
        "/var/lib/openclaw-state/config:/home/node/.openclaw"
        "/var/lib/openclaw-state/auth-secret:/home/node/.config/openclaw"
      ];
    };
  };
  systemd.tmpfiles.rules = [
    "d /var/lib/openclaw/config 0750 1000 1000 -"
    "d /var/lib/openclaw/auth-secret 0700 1000 1000 -"
  ];
  system.stateVersion = "26.11";
}
