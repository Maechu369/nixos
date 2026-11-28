{ config, ... }:
{
  services.step-ca = {
    enable = true;
    address = "0.0.0.0";
    port = 9000;
    openFirewall = false;
    intermediatePasswordFile = "/var/lib/step-ca/config/password.txt";
    settings = {
      root = "/var/lib/step-ca/certs/root_ca.crt";
      crt = "/var/lib/step-ca/certs/intermediate_ca.crt";
      key = "/var/lib/step-ca/secrets/intermediate_ca_key";
      dnsNames = [ "step-ca.home.arpa" ];
      db = {
        type = "badgerv2";
        dataSource = "/var/lib/step-ca/db";
      };
      authority = {
        policy = {
          x509 = {
            allow = {
              dns = [
                "*.home.arpa"
              ];
            };
            allowWildcardNames = false;
          };
        };
        provisioners = [
          {
            type = "ACME";
            name = "acme";
            challenges = [ "http-01" ];
          }
        ];
      };
      tls = {
        cipherSuites = [ "TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256" ];
        minVersion = 1.2;
        maxVersion = 1.3;
        renegotiation = false;
      };
    };
  };

  networking.firewall.extraInputRules = ''
    ip saddr 192.168.2.0/24 tcp dport 9000 accept
    iifname "tailscale0" tcp dport 9000 accept
  '';
  security.acme = {
    acceptTerms = true;
    defaults.email = "maechu369@home.arpa";
  };
}
