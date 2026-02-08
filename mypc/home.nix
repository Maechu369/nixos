{ username, xremap }:
{ config, pkgs, plasma-manager, nixvim, ... }: {
  _module.args = { inherit username; };
  imports = [
    xremap.homeManagerModules.default
    ../component/home
    ../component/home/desktop
    ./opencode.nix
  ];
  xdg.userDirs.enable = true;
}

