{ ... }:
let
  hostAddress = "192.168.64.1";
  localAddress = "192.168.64.4";
  domain = "searxng.home.arpa";
in
{
  containers."searxng" = {
    autoStart = true;
    privateNetwork = true;
    privateUsers = "pick";
    inherit hostAddress;
    inherit localAddress;
    config = ./searxng.nix;
  };
  services.nginx.virtualHosts."${domain}" = {
    forceSSL = true;
    useACMEHost = "searxng.home.arpa";
    locations."/" = {
      proxyPass = "http://${localAddress}:8080";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        allow 192.168.2.6/32;
        deny all;
      '';
    };
    listen = [
      {
        addr = "0.0.0.0";
        port = 443;
        ssl = true;
      }
      {
        addr = "0.0.0.0";
        port = 80;
      }
    ];
  };
  security.acme.certs."${domain}" = {
    server = "https://step-ca.home.arpa:9000/acme/acme/directory";
    webroot = "/var/lib/acme/acme-challenge";
    group = "nginx";
  };
}
