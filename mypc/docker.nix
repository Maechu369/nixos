{ ... }: {
  virtualisation.docker = {
    # https://nixos.wiki/wiki/Nvidia
    daemon.settings.features.cdi = true;
  };
}
