{ pkgs, ... }: {
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    prefix = "C-q";
    extraConfig = builtins.readFile ./tmux.conf;
    plugins = with pkgs; [
      tmuxPlugins.sensible
      tmuxPlugins.resurrect
      tmuxPlugins.continuum
    ];
    terminal = "tmux-256color";
  };
}

