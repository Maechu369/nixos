username:
arg@{ config, pkgs, plasma-manager, nixvim, ... }:
let
  args = arg // {
    inherit username;
  };
in {
  imports = [
    ../component/home
    ../component/home/desktop
  ];
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
  };
  xdg.userDirs.enable = true;
}
