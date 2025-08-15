username:
arg@{ config, pkgs, plasma-manager, nixvim, ... }:
let
  args = arg // {
    inherit username;
    desktop = true;
  };
in import ../component/home args
