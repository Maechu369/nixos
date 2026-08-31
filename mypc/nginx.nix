{ ... }:
{
  services.nginx = {
    enable = true;
  };
  networking.firewall = {
    allowedTCPPorts = [
      80
      443
    ];
  };
  services.nginx.virtualHosts."files.home.arpa" = {
    forceSSL = true;
    useACMEHost = "files.home.arpa";
    locations."/" = {
      root = "/var/lib/files";
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
  security.acme.certs."files.home.arpa" = {
    server = "https://step-ca.home.arpa:9000/acme/acme/directory";
    webroot = "/var/lib/acme/acme-challenge";
    group = "nginx";
  };
}
