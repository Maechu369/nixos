{ pkgs, lib, ... }:
let
  mac = "02:00:00:00:00:01";
  openclaw = import ./openclaw.nix { inherit pkgs; };
in
{
  networking.hostName = "openclaw";
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.config.permittedInsecurePackages = [
    "openclaw-2026.7.1"
  ];
  environment.systemPackages = [
    openclaw
    pkgs.nodejs_22
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
        mountPoint = "/var/lib";
        image = "/var/lib/volumes/openclaw/var-lib.img";
        size = 1024;
      }
      {
        autoCreate = true;
        mountPoint = "/home/openclaw";
        image = "/var/lib/volumes/openclaw/home.img";
        size = 8191;
      }
    ];
    interfaces = [
      {
        type = "tap";
        id = "vm-openclaw";
        inherit mac;
      }
    ];
    mem = 2047;
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
  systemd.services."openclaw" = {
    enable = true;
    description = "OpenClaw Gateway";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    environment = {
      NODE_ENV = "production";
      HOME = "/home/openclaw";
      OPENCLAW_DEBUG = "1";
      PATH = lib.mkForce (
        lib.makeBinPath (
          with pkgs;
          [
            nodejs_22
            coreutils
            findutils
            gnugrep
            gnused
            systemd
          ]
        )
      );
    };
    serviceConfig = {
      Type = "simple";
      ExecStart = "${openclaw}/bin/openclaw gateway";
      WorkingDirectory = openclaw;
      KillMode = "control-group";
      KillSignal = "SIGTERM";
      TimeoutStopSec = 15;
      Restart = "always";
      RestartSec = 5;
      User = "openclaw";
      Group = "openclaw";
      StateDirectory = "openclaw";
      RuntimeDirectory = "openclaw";
      # ProtectSystem = "strict";
      # BindPaths = [ "/home/openclaw" ];
      # ProtectHome = true;
      NoNewPrivileges = true;
      PrivateTmp = true;
    };
  };
  users.users.openclaw = {
    isSystemUser = true;
    group = "openclaw";
  };
  users.groups."openclaw" = { };
  system.stateVersion = "26.11";
}
