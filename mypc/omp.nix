{ pkgs, ... }:
let
  yaml = pkgs.formats.yaml { };
in
{
  programs.omp = {
    enable = true;
    settings = {
      startup = {
        quiet = true;
        setupWizard = false;
      };
      theme.dark = "titanium";
      modelRoles.default = "llama-swap/ornith1.5:35b-a3b";
    };
  };
  home.file.".omp/agent/models.yml" = {
    source = yaml.generate "omp-models.yml" {
      providers.llama-swap = {
        baseUrl = "http://192.168.64.2:8080/v1";
        api = "openai-completions";
        auth = "none";
        discovery = {
          type = "openai-models-list";
        };
        compat = {
          supportsDeveloperRole = false;
          supportsReasoningEffort = false;
        };
      };
    };
  };
}
