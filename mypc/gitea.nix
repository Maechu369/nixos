{ ... }:
{
  services.gitea = {
    enable = true;
    database = {
      type = "sqlite3";
    };
    settings = {
      server = {
        HTTP_ADDR = "127.0.0.1";
        HTTP_PORT = 3000;
        DOMAIN = "gitea.home.arpa";
        ROOT_URL = "http://gitea.home.arpa";
      };
    };
    lfs.enable = true;
    user = "gitea";
    group = "gitea";
  };
  services.nginx.virtualHosts."gitea.home.arpa" = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:3000";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
      '';
    };
  };
}
