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
      modelRoles.default = "llama-swap/swift1.5-flash-next:125b-a6b";
    };
  };
  home.file.".omp/agent/models.yml" = {
    source = yaml.generate "omp-models.yml" {
      providers.llama-swap = {
        baseUrl = "http://localhost:8081/v1";
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
