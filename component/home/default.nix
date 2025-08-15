args@{ config, pkgs, username, plasma-manager, nixvim, ... }:
{
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.05";
  home.packages = (import ./packages.nix args)
    ++ (import ./desktop/packages.nix args);
  xdg.userDirs.enable = true;
  xdg.configFile = {
    # "kxkbrc".text = builtins.readFile ./kxkbrc;
    # "kwinrc".text = builtins.readFile ./kwinrc;
    fcitx5.source = ./fcitx5;
    fcitx5.recursive = true;
    "libskk/rules".source = ./libskk;
    "libskk/rules".recursive = true;
  };
  programs = (import ./programs.nix args)
    // (import ./desktop/programs.nix args);
  services = import ./services args;
}
