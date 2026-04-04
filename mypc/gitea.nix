{ ... }:
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
        DOMAIN = "mypc";
      };
    };
    lfs.enable = true;
    user = "gitea";
    group = "gitea";
  };
  networking.firewall = {
    extraInputRules = ''
      ip saddr 100.0.0.0/8 tcp dport 3000 accept
      ip saddr 192.168.2.0/24 tcp dport 3000 accept
    '';
  };
}
