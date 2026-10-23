{ lib, ... }:
{
  networking = {
    firewall = {
      enable = true;
    };
    useHostResolvConf = lib.mkForce false;
  };
  system.stateVersion = "26.11";
}
