args @ {lib, ...}:
{
  home-manager.enable = true;
  git = {
    enable = true;
    userName = "Maechu369";
    userEmail = "90904222+Maechu369@users.noreply.github.com";
    extraConfig = {
      core = {
        quotepath = false;
      };
      merge.conflictStyle = "zdiff3";
    };
    delta = {
      enable = true;
    };
  };
  zsh = import zsh/zsh.nix args;
  eza = {
    enable = true;
    git = true;
    icons = "auto";
  };
  fzf = {
    enable = true;
    enableZshIntegration = true;
  };
  starship = {
    enable = true;
    enableZshIntegration = true;
    settings = builtins.fromTOML (builtins.readFile ./starship.toml);
  };
}
