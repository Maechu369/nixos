{ pkgs, ... }: {
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultOptions = [ "--height 40%" "--layout reverse" "--border top" ];
    tmux = {
      enableShellIntegration = true;
      shellIntegrationOptions = [ "--bottom,40%" ];
    };
  };
}

