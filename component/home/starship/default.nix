{ pkgs, ... }: {
  programs.starship = {
    enable = true;
    enableZshIntegration = false;
    settings = builtins.fromTOML (builtins.readFile ./starship.toml);
  };
}
