{ pkgs, lib, ... }:
{
  programs.nixvim.plugins = {
    avante = {
      enable = true;
    };
  };
}
