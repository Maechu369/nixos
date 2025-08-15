args@{ config, pkgs, username, desktop ? null, plasma-manager, nixvim, ... }: {
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.05";
  home.packages = (import ./packages.nix args)
    ++ (if desktop != null then import ./desktop/packages.nix args else [ ]);
  home.file = {
    "bin" = {
      source = ./bin;
      recursive = true;
    };
  };
  xdg.userDirs.enable = true;
  xdg.configFile = if desktop != null then {
    # "kxkbrc".text = builtins.readFile ./kxkbrc;
    # "kwinrc".text = builtins.readFile ./kwinrc;
    "fcitx5" = {
      source = ./fcitx5;
      recursive = true;
    };
    "libskk/rules" = {
      source = ./libskk;
      recursive = true;
    };
  } else
    { };
  programs = (import ./programs.nix args)
    // (if desktop != null then import ./desktop/programs.nix args else { });
  services = import ./services args;
}
