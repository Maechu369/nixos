{ ... }:
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
        suggestion = {
          accept = "<Tab>";
          dismiss = "<C-]>";
          next = "<M-]>";
          prev = "<M-[>";
        };
        provider = "llama_swap";
        input.provider = "dressing";
        auto_suggestion_provider = "llama_swap";
        providers = {
          llama_swap = {
            __inherited_from = "openai";
            endpoint = "http://localhost:8080/v1";
            model = "qwen2.5-coder:3b";
            extra_request_body = {
              temperature = 1;
              max_tokens = 8192;
            };
            api_key_name = "AVANTE_DUMMY";
          };
        };
        behaviour = {
          auto_suggestions = true;
        };
      };
    };
  };
  home.sessionVariables = {
    AVANTE_DUMMY = "dummy";
  };
}
