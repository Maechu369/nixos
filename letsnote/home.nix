{ config, pkgs, plasma-manager, nixvim, username, xremap, ... }: {
  _module.args = { inherit username; };
  imports = [
    xremap.homeManagerModules.default
    ../component/home
    ../component/home/desktop
  ];
  xdg.userDirs.enable = true;
}

