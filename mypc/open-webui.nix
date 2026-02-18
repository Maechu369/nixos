{ pkgs, ... }: {
  services.open-webui = {
    enable = true;
    package = pkgs.open-webui;
    host = "0.0.0.0";
    openFirewall = true;
  };
  networking.firewall = {
    extraInputRules = ''
      ip saddr 100.0.0.0/8 tcp dport 8080 accept
      ip saddr 192.168.2.0/24 tcp dport 8080 accept
    '';
  };
}

