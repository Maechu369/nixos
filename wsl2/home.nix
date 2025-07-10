args @ {config, pkgs, lib, ...}:

{
  home.username = "nixos";
  home.homeDirectory = "/home/nixos";
  home.stateVersion = "25.05";
  home.packages = import ../component/packages.nix args;
  programs = import ../component/programs.nix args;
}
