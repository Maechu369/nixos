{ pkgs, lib, ... }:
let
  llama-cpp = pkgs.llama-cpp.override {
    cudaSupport = true;
    blasSupport = true;
  };
  llama-server = lib.getExe' llama-cpp "llama-server";
in
{
  imports = [
    ../../../component/unfree.nix
  ];
  services.llama-swap = {
    enable = true;
    listenAddress = "0.0.0.0";
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
  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [
        8080
      ];
    };
    useHostResolvConf = lib.mkForce false;
  };
  services.resolved.enable = true;
  system.stateVersion = "26.11";
}
