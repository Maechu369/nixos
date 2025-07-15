inputs @ {config, pkgs, lib, ...}:

{
  home.username = "hiroki";
  home.homeDirectory = "/home/hiroki";
  home.stateVersion = "25.05";
  home.packages = import ../component/packages.nix inputs;
  programs = import ../component/programs.nix inputs;
}
