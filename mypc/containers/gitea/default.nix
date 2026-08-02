{ ... }:
{
  containers."gitea" = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "192.168.64.1";
    localAddress = "192.168.64.3";
    config = ./gitea.nix;
  };
  services.nginx.virtualHosts."gitea.home.arpa" = {
    forceSSL = true;
    useACMEHost = "gitea.home.arpa";
    locations."/" = {
      proxyPass = "http://192.168.64.3:3000";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        allow 100.64.0.0/10;
        allow 192.168.2.3/32;
        deny all;
      '';
    };
    listen = [
      {
        addr = "0.0.0.0";
        port = 443;
        ssl = true;
      }
    ];
  };
  security.acme.certs."gitea.home.arpa" = {
    server = "https://step-ca.home.arpa:9000/acme/acme/directory";
    webroot = "/var/lib/acme/acme-challenge";
    group = "nginx";
  };
}
