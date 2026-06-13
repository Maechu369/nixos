{ pkgs, lib, ... }:
let
  llama-cpp = pkgs.llama-cpp.override {
    cudaSupport = true;
    blasSupport = true;
  };
  llama-server = lib.getExe' llama-cpp "llama-server";
in
{
  services.llama-swap = {
    enable = true;
    settings = {
      healthCheckTimeout = 120;
      models = {
        "qwen3.5:4b" = {
          cmd = ''
            ${llama-server}
              --port ''${PORT}
              -m /var/lib/llama/models/qwen3.5
              -ngl 99
              -c 8192
          '';
          aliases = ["qwen"];
        };
      };
    };
  };
}
