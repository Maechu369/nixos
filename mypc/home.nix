{
  config,
  pkgs,
  plasma-manager,
  nixvim,
  username,
  xremap,
  ...
}:
{
  _module.args = { inherit username; };
  imports = [
    xremap.homeManagerModules.default
    ../component/home
    ../component/home/desktop
    ./opencode
    ./nixvim.nix
  ];
  xdg.userDirs.enable = true;
}
