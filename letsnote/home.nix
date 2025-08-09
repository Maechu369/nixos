username:
arg@{ config, pkgs, plasma-manager, nixvim, ... }:
let args = arg // { inherit username; };
in {
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.05";
  home.packages = (import ../component/packages.nix args)
    ++ (import ../component/desktop/packages.nix args);
  xdg.userDirs.enable = true;
  xdg.configFile = {
    # "kxkbrc".text = builtins.readFile ./kxkbrc;
    # "kwinrc".text = builtins.readFile ./kwinrc;
    fcitx5.source = ./fcitx5;
    fcitx5.recursive = true;
    "libskk/rules".source = ./libskk;
    "libskk/rules".recursive = true;
  };
  programs = (import ../component/programs.nix args)
    // (import ../component/desktop/programs.nix args);
}
