{ pkgs, ... }:
{
  services.ollama = {
    enable = false;
    package = pkgs.ollama-cuda;
    loadModels = [ "qwen3.5:4b" ];
  };
}
