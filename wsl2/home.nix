{config, pkgs, ...}:

{
  home.username = "hiroki";
  home.homeDirectory = "/home/hiroki";
  home.stateVersion = "25.05";
  home.packages = with pkgs; [
  ];
  programs = import ../component/programs.nix;
}
