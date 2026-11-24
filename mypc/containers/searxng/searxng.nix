{
  lib,
  pkgs,
  config,
  ...
}:
let
  sopsAgeKeyFile = "/var/lib/sops-nix/keys.txt";
in
{
  environment.systemPackages = with pkgs; [ age ];

  sops = {
    age.keyFile = sopsAgeKeyFile;
    age.generateKey = true;
    defaultSopsFile = ../../../secrets/searxng.env;
    defaultSopsFormat = "dotenv";

    secrets."searxng-env" = {
      format = "dotenv";
      mode = "0400";
      owner = "searx";
      group = "searx";
    };
  };

  services.searx = {
    enable = true;
    environmentFile = config.sops.secrets."searxng-env".path;
    settings = {
      server = {
        port = 8080;
        bind_address = "0.0.0.0";
        limiter = false;
        secret_key = "$SEARXNG_SECRET";
      };
      search = {
        formats = [
          "html"
          "json"
        ];
        default_lang = "ja-JP";
      };
    };
    openFirewall = true;
  };

  networking = {
    firewall = {
      enable = true;
    };
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];
    useHostResolvConf = lib.mkForce false;
  };

  system.stateVersion = "26.11";
}
