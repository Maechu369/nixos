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
    port = 8080;
    settings = {
      healthCheckTimeout = 120;
      models = {
        "qwen3.5:4b" = {
          # hf download unsloth/Qwen3.5-4B-GGUF Qwen3.5-4B-Q4_K_M.gguf --local-dir .
          cmd = ''
            ${llama-server}
              --port ''${PORT}
              -m /var/lib/llama/models/Qwen3.5-4B-Q4_K_M.gguf
              -ngl 99
              -c 8192
              --no-webui
              --jinja
          '';
          aliases = [ "qwen3.5" ];
        };
        "qwen2.5-coder:3b" = {
          # hf download Qwen/Qwen2.5-Coder-3B-Instruct-GGUF qwen2.5-coder-3b-instruct-q4_k_m.gguf --local-dir .
          cmd = ''
            ${llama-server}
              --port ''${PORT}
              -m /var/lib/llama/models/qwen2.5-coder-3b-instruct-q4_k_m.gguf
              -ngl 99
              -c 8192
              --no-webui
              --jinja
          '';
          aliases = [ "qwen2.5-coder" ];
        };
      };
    };
  };
  services.nginx.virtualHosts."llama.home.arpa" = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:8080";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
      '';
    };
  };
}
