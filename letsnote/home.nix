args@{ config, pkgs, nixvim, ... }:

{
  home.username = "hiroki";
  home.homeDirectory = "/home/hiroki";
  home.stateVersion = "25.05";
  home.packages = (import ../component/packages.nix args);
  home.file = {
    "./config/kxkbrc".text = builtins.readFile ./kxkbrc;
    # ".config/kwinrc".text = builtins.readFile ./kwinrc;
  };
  programs = (import ../component/programs.nix args)
    // (import ../component/desktop/programs.nix args);
}
