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
    port = 8000;
    settings = {
      healthCheckTimeout = 120;
      models = {
        "qwen3.5:4b" = {
          cmd = ''
            ${llama-server}
              --port ''${PORT}
              -m /var/lib/llama/models/Qwen3.5-4B-Q4_K_M.gguf
              -ngl 99
              -c 8192
              --no-webui
          '';
          aliases = ["qwen"];
        };
      };
    };
  };
}
