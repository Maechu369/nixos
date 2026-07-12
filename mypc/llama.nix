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
        "qwen3.6:35b-a3b" = {
          # hf download unsloth/Qwen3.6-35B-A3B-GGUF Qwen3.6-35B-A3B-UD-Q4_K_M.gguf --local-dir . --dry-run
          cmd = ''
            ${llama-server}
              --port ''${PORT}
              -m /var/lib/llama/models/Qwen3.6-35B-A3B-UD-Q4_K_M.gguf
              -ngl 999
              -ot "blk\.(0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18)\.ffn_.*_exps\.=CUDA0,exps=CPU" \
              -c 65536
              --flash-attn on
              --cache-type-k q8_0
              --cache-type-v q8_0
              --jinja
              --spec-type ngram-simple --spec-draft-n-max 64
              --no-webui
          '';
          aliases = [ "qwen3.6" ];
        };
        "qwen3.5:4b" = {
          # hf download unsloth/Qwen3.5-4B-GGUF Qwen3.5-4B-Q4_K_M.gguf --local-dir . --dry-run
          cmd = ''
            ${llama-server}
              --port ''${PORT}
              -m /var/lib/llama/models/Qwen3.5-4B-Q4_K_M.gguf
              -ngl 999
              -c 65536
              --flash-attn on
              --cache-type-k q8_0
              --cache-type-v q8_0
              --jinja
              --spec-type ngram-simple --spec-draft-n-max 64
              --no-webui
          '';
          aliases = [ "qwen3.5" ];
        };
        "qwen2.5-coder:14b" = {
          # hf download Qwen/Qwen2.5-Coder-14B-Instruct-GGUF qwen2.5-coder-14b-instruct-q4_k_m.gguf --local-dir . --dry-run
          cmd = ''
            ${llama-server}
              --port ''${PORT}
              -m /var/lib/llama/models/qwen2.5-coder-14b-instruct-q4_k_m.gguf
              -ngl 999
              -c 32768
              --flash-attn on
              --jinja
              --spec-type ngram-simple --spec-draft-n-max 64
              --no-webui
          '';
          aliases = [ "qwen2.5-coder" ];
        };
        "qwen2.5-coder:3b" = {
          # hf download Qwen/Qwen2.5-Coder-3B-Instruct-GGUF qwen2.5-coder-3b-instruct-q4_k_m.gguf --local-dir . --dry-run
          cmd = ''
            ${llama-server}
              --port ''${PORT}
              -m /var/lib/llama/models/qwen2.5-coder-3b-instruct-q4_k_m.gguf
              -ngl 999
              -c 32768
              --flash-attn on
              --jinja
              --spec-type ngram-simple --spec-draft-n-max 64
              --no-webui
          '';
          aliases = [ "qwen2.5-coder:3b" ];
        };
      };
    };
  };
  services.nginx.virtualHosts."llama.home.arpa" = {
    forceSSL = true;
    useACMEHost = "llama.home.arpa";
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
  security.acme.certs."llama.home.arpa" = {
    server = "https://step-ca.home.arpa:9000/acme/acme/directory";
    webroot = "/var/lib/acme/acme-challenge";
    group = "nginx";
  };
}
