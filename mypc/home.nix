{
  config,
  pkgs,
  plasma-manager,
  nixvim,
  oh-my-pi,
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
    ./opencode
    ./omp.nix
    ./nixvim.nix
  ];
  xdg.userDirs.enable = true;
}
