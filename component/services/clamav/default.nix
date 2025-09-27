{pkgs, ...}:
{
  package = pkgs.clamav;
  daemon.enable = true;
  updater.enable = true;
}
