{ ... }: {
  imports = [ ./displayManager.nix ./input.nix ./sound.nix ./steam.nix ];
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}

