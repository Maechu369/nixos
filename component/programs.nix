args @ {lib, pkgs, ...}:
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
    defaultOptions = [
      "--height 40%"
      "--layout reverse"
      "--border top"
    ];
    tmux = {
      enableShellIntegration = true;
      shellIntegrationOptions = [
        "--bottom,40%"
      ];
    };
  };
  starship = {
    enable = true;
    enableZshIntegration = true;
    settings = builtins.fromTOML (builtins.readFile ./starship.toml);
  };
  tmux = {
    enable = true;
    keyMode = "emacs";
    prefix = "C-q";
    extraConfig = "";
    plugins = with pkgs; [
      tmuxPlugins.sensible
      tmuxPlugins.resurrect
      tmuxPlugins.continuum
    ];
    terminal = "tmux-256color";
  };
}
