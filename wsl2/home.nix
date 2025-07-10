{config, pkgs, ...}:

{
  home.username = "nixos";
  home.homeDirectory = "/home/nixos";
  home.stateVersion = "25.05";
  # home.packages =  [pkgs.zsh pkgs.tmux pkgs.neovim];
  home.packages = import ../component/packages.nix pkgs;
  programs = import ../component/programs.nix;
}
