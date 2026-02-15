{ pkgs, ... }: {
  services.open-webui = {
    enable = true;
    package = pkgs.open-webui;
    host = "0.0.0.0";
    openFirewall = true;
  };
}

