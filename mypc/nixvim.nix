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
        provider = "llama_swap";
        input.provider = "dressing";
        auto_suggestion_provider = "llama_swap";
        providers = {
          llama_swap = {
            __inherited_from = "openai";
            endpoint = "http://localhost:8080/v1";
            model = "qwen3.6:35b-a3b";
            api_key_name = "AVANTE_DUMMY";
          };
        };
        behaviour = {
          auto_suggestions = false;
        };
      };
    };
    llm = {
      enable = true;
      settings = {
        backend = "openai";
        url = "http://localhost:8080/v1";
        model = "qwen2.5-coder:14b";
      };
    };
  };
  # home.sessionVariables = {
  #   AVANTE_DUMMY = "dummy";
  # };
}
