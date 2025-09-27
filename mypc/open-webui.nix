{ pkgs, ... }: {
  services.open-webui = {
    enable = true;
    package = pkgs.open-webui;
  };
}
