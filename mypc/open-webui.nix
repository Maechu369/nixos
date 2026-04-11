{ pkgs, ... }:
{
  services.open-webui = {
    enable = true;
    package = pkgs.open-webui;
    host = "127.0.0.1";
    openFirewall = false;
  };
  services.nginx.virtualHosts."webui.home.arpa" = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:8080";
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
