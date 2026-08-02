{ lib, ... }:
{
  services.gitea = {
    enable = true;
    database = {
      type = "sqlite3";
    };
    settings = {
      server = {
        HTTP_ADDR = "0.0.0.0";
        HTTP_PORT = 3000;
        DOMAIN = "gitea.home.arpa";
        ROOT_URL = "http://gitea.home.arpa";
        SSH_PORT = 22;
        DISABLE_SSH = false;
      };
    };
    lfs.enable = true;
    user = "gitea";
    group = "gitea";
  };
  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [
        22
        3000
      ];
    };
    useHostResolvConf = lib.mkForce false;
  };
  system.stateVersion = "26.11";
}
