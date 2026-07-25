{
  username,
  pkgs,
  config,
  lib,
  ...
}:
let
  directory = "/mnt/samba";
in
{
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        workgroup = "WORKGROUP";
        "server string" = "mypc";
        "netbios name" = "mypc";
        security = "user";
        "hosts allow" =
          "192.168.2.2 192.168.2.3 192.168.2.4 192.168.2.6 192.168.2.14 127.0.0.1 100.64.0.0/10";
        "hosts deny" = "0.0.0.0/0";
        "map to guest" = "never";
        "min protocol" = "SMB2";
        "invalid users" = [ "root" ];
      };
      shared = {
        path = directory;
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "valid users" = username;
        "create mask" = "0664";
        "directory mask" = "0775";
        "force group" = "sambashare";
      };
    };
  };
  systemd.services.samba-smbd = {
    unitConfig.RequiresMountsFor = lib.mkForce [ directory ];
  };
  users.groups.sambashare = { };
  users.users."${username}".extraGroups = [ "sambashare" ];
  fileSystems."${directory}" = {
    device = "tank/samba";
    fsType = "zfs";
    noCheck = true;
  };
}
