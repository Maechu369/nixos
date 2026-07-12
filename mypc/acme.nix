{ config, ... }:
{
  services.step-ca = {
    enable = true;
    address = "0.0.0.0";
    port = 9000;
    openFirewall = true;
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
        provisioners = [
          {
            type = "ACME";
            name = "acme";
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
  security.acme = {
    acceptTerms = true;
    defaults.email = "maechu369@home.arpa";
  };
}
