{ pkgs, ... }: {
  home.packages = with pkgs; [ opencode ];
  xdg.configFile."opencode/opencode.json" = { source = ./opencode.json; };
}

