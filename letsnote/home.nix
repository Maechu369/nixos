args@{ config, pkgs, plasma-manager, nixvim, ... }:

{
  home.username = "hiroki";
  home.homeDirectory = "/home/hiroki";
  home.stateVersion = "25.05";
  home.packages = (import ../component/packages.nix args)
    ++ (import ../component/desktop/packages.nix args);
  xdg.configFile = {
    fcitx5.source = ./fcitx5;
    fcitx5.recursive = true;
    "libskk/rules".source = ./libskk;
    "libskk/rules".recursive = true;
    # "kxkbrc".text = builtins.readFile ./kxkbrc;
    # "kwinrc".text = builtins.readFile ./kwinrc;
  };
  programs = (import ../component/programs.nix args)
    // (import ../component/desktop/programs.nix args);
}
