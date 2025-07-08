{config, pkgs, ...}:

{
  home.username = "hiroki";
  home.homeDirectory = "/home/hiroki";
  home.stateVersion = "25.05";
  home.packages = import ../component/packages.nix pkgs;
  programs = import ../component/programs.nix;
}
