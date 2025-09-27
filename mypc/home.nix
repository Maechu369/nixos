{ username, xremap }:
{ config, pkgs, plasma-manager, nixvim, ... }: {
  imports = [
    xremap.homeManagerModules.default
    # (import ../component/home/desktop/xremap.nix)
    (import ../component/home username)
    (import ../component/home/desktop username)
  ];
  xdg.userDirs.enable = true;
}
