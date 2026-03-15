{ pkgs, lib, ... }:
{
  programs.nixvim.plugins = {
    nui = {
      enable = true;
    };
    dressing = {
      enable = true;
    };
    avante = {
      enable = true;
      settings = {
        provider = "ollama";
        auto_suggestion_provider = "ollama";
        providers = {
          ollama = {
            local = true;
            endpoint = "localhost:11434";
            extra_request_body = {
              temperature = 1;
              max_tokens = 128000;
            };
            model = "qwen3.5:4b";
            is_env_set.__raw = ''require("avante.providers.ollama").check_endpoint_alive'';
          };
        };
        behaviour = {
          auto_suggestions = true;
        };
      };
    };
  };
}
