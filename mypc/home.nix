username:
arg@{ config, pkgs, plasma-manager, nixvim, ... }:
let
  args = arg // { inherit username; };
in import ../component/home args
