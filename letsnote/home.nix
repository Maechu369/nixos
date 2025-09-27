username:
{ config, pkgs, plasma-manager, nixvim, ... }:
{
  imports = [
    (import ../component/home username)
    (import ../component/home/desktop username)
  ];
  xdg.userDirs.enable = true;
}
