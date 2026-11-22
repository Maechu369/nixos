{
  pkgs,
  lib,
  ip,
  username,
  ...
}:
let
  llama-server = lib.getExe' pkgs.llama-cpp-cuda "llama-server";
  docker = lib.getExe' pkgs.docker "docker";
  domain = "llama.home.arpa";
  port = 8081;
  strata-key = "passwordpassword";
in
{
  hardware.nvidia-container-toolkit = {
    enable = true;
  };
  systemd.services."llama-swap".serviceConfig = {
    Group = "docker";
  };
  services.llama-swap = {
    enable = true;
    listenAddress = "0.0.0.0";
    openFirewall = false;
    inherit port;
    settings = {
      healthCheckTimeout = 600;
      models = {
        "ornith1.5:35b-a3b" = {
          # hf download ornith-ai/Ornith-1.5-35B-A3B-GGUF Ornith-1.5-35B-Q4_K_M.gguf --local-dir . --dry-run
          cmd = ''
            ${llama-server}
              --port ''${PORT}
              -m /var/lib/llama/models/Ornith-1.5-35B-Q4_K_M.gguf
              -ngl 999
              -ot "blk\.(0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17)\.ffn_.*_exps\.=CUDA0,exps=CPU" \
              -c 131072
              --flash-attn on
              --cache-type-k q8_0
              --cache-type-v q8_0
              --jinja
              --spec-type ngram-simple --spec-draft-n-max 64
              --no-webui
          '';
          aliases = [ "ornith1.5" ];
        };
        "qwen3.6:35b-a3b" = {
          # hf download unsloth/Qwen3.6-35B-A3B-GGUF Qwen3.6-35B-A3B-UD-Q4_K_M.gguf --local-dir . --dry-run
          cmd = ''
            ${llama-server}
              --port ''${PORT}
              -m /var/lib/llama/models/Qwen3.6-35B-A3B-UD-Q4_K_M.gguf
              -ngl 999
              -ot "blk\.(0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17)\.ffn_.*_exps\.=CUDA0,exps=CPU" \
              -c 131072
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
              --cache-type-k q8_0
              --cache-type-v q8_0
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
              --cache-type-k q8_0
              --cache-type-v q8_0
              --jinja
              --spec-type ngram-simple --spec-draft-n-max 64
              --no-webui
          '';
          aliases = [ "qwen2.5-coder:3b" ];
        };
        "gemma4:12b" = {
          # hf download unsloth/gemma-4-12b-it-GGUF gemma-4-12b-it-Q4_K_M.gguf --local-dir . --dry-run
          cmd = ''
            ${llama-server}
              --port ''${PORT}
              -m /var/lib/llama/models/gemma-4-12b-it-Q4_K_M.gguf
              -ngl 999
              -c 131072
              --flash-attn on
              --cache-type-k q8_0
              --cache-type-v q8_0
              --jinja
              --spec-type ngram-simple --spec-draft-n-max 64
              --no-webui
          '';
          aliases = [ "gemma4:12b" ];
        };
        "qwen3.8-flash-next:125b-a3b" = {
          cmd = ''
            ${docker} run
              --rm
              --name strata
              --device=nvidia.com/gpu=all
              -p 127.0.0.1:18081:8080
              --ulimit memlock=-1:-1
              --shm-size 2g
              --stop-timeout 120
              -v /strata-data:/data
              -e FAMILY=qwen
              -e MODEL=IQ3_XXS
              -e KV=int8
              -e CONTEXT=128k
              -e API_KEY=${strata-key}
              ghcr.io/niko1221/strata:0.2.17-cuda13
          '';
          proxy = "http://127.0.0.1:18080";
          # llama-swap runs this (docker stop) to gracefully unload and
          # free the GPU, instead of letting docker run swallow SIGTERM.
          # unloadTimeout must exceed the docker stop timeout: llama-swap
          # force-kills the docker run client once it expires, which can
          # leave the strata container running and holding its VRAM.
          cmdStop = "${docker} stop --timeout 120 strata";
          unloadTimeout = 150;
          aliases = [ "qwen3.8" ];
        };
      };
    };
  };
  networking.firewall.extraInputRules = ''
    ip saddr { 192.168.65.0/24 } tcp dport ${toString port} accept
  '';
  services.nginx.virtualHosts."llama.home.arpa" = {
    forceSSL = true;
    useACMEHost = domain;
    locations."/" = {
      proxyPass = "http://localhost:${toString port}";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        allow 100.64.0.0/10;
        allow ${ip.mypc}/32;
        allow 192.168.65.2/32;
        allow ${ip.letsnote}/32;
        deny all;
      '';
    };
    listen = [
      {
        addr = "0.0.0.0";
        port = 443;
        ssl = true;
      }
      {
        addr = "0.0.0.0";
        port = 80;
      }
    ];
  };
  services.nginx.virtualHosts."127.0.0.1:18080" = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:18081";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_set_header Authorization "Bearer ${strata-key}";
        proxy_buffering off;
        proxy_read_timeout 3600s;
        proxy_send_timeout 3600s;
        allow 127.0.0.1/32;
        deny all;
      '';
    };
    listen = [
      {
        addr = "127.0.0.1";
        port = 18080;
      }
    ];
  };
  security.acme.certs."${domain}" = {
    server = "https://step-ca.home.arpa:9000/acme/acme/directory";
    webroot = "/var/lib/acme/acme-challenge";
    group = "nginx";
  };
}
