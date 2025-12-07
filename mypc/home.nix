{ username, xremap }:
{ config, pkgs, plasma-manager, nixvim, ... }: {
  imports = [
    xremap.homeManagerModules.default
    (import ../component/home username)
    (import ../component/home/desktop username)
    (import ./opencode.nix)
  ];
  xdg.userDirs.enable = true;
}
