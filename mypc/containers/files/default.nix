{ ... }:
let
  hostAddress = "192.168.64.1";
  localAddress = "192.168.64.5";
  domain = "files.home.arpa";
  guestFileRoot = "/var/lib/files";
  hostFileRoot = "/var/lib/files";
in
{
  containers."files" = {
    autoStart = true;
    privateNetwork = true;
    privateUsers = "pick";
    inherit hostAddress;
    inherit localAddress;
    config = ./files.nix;
    bindMounts."${guestFileRoot}" = {
      hostPath = hostFileRoot;
      isReadOnly = true;
    };
  };
  services.nginx.virtualHosts."${domain}" = {
    forceSSL = true;
    useACMEHost = domain;
    locations."/" = {
      root = guestFileRoot;
      index = "index.html";
      extraConfig = ''
        autoindex on;
        autoindex_exact_size on;
        autoindex_localtime on;

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
