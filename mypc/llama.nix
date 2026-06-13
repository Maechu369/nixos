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
          cmd = ''
            ${llama-server}
              --port ''${PORT}
              -m /var/lib/llama/models/Qwen3.5-4B-Q4_K_M.gguf
              -ngl 99
              -c 8192
              --no-webui
              --jinja
          '';
          aliases = [ "qwen" ];
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
