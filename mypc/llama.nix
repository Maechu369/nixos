{ pkgs, ... }:
{
  services.llama-cpp = {
    enable = true;
    package = pkgs.llama-cpp;
    port = 11433;
  };
}
