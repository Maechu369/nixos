{
  config,
  pkgs,
  plasma-manager,
  nixvim,
  username,
  ip,
  xremap,
  ...
}:
{
  _module.args = { inherit username ip; };
  imports = [
    xremap.homeManagerModules.default
    ../component/home
    ../component/home/desktop
  ];
  xdg.userDirs.enable = true;
}
