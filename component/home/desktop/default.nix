username:
{ pkgs, ... }: {
  _module.args = { inherit username; };
  imports = [
    ./alacritty.nix
    ./firefox.nix
    ./thunderbird.nix
    ./vscode.nix
    ./plasma.nix
    ./xremap.nix
  ];
  xdg.configFile = {
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
  };
  home = {
    packages = with pkgs; [
      libreoffice-fresh
      libnotify
      obsidian
      slack
      discord
      gparted
      graphviz
      prismlauncher
      filezilla
      pinta
    ];
  };
}

