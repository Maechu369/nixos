args@{ config, pkgs, nixvim, ... }:

{
  home.username = "hiroki";
  home.homeDirectory = "/home/hiroki";
  home.stateVersion = "25.05";
  home.packages = (import ../component/packages.nix args);
  programs = (import ../component/programs.nix args)
    // (import ../component/desktop/programs.nix args);
}
