args@{ config, lib, pkgs, ... }: {
  home-manager.enable = true;
  git = {
    enable = true;
    userName = "Maechu369";
    userEmail = "m6a7e0d8a3@gmail.com";
    extraConfig = {
      core = { quotepath = false; };
      merge.conflictStyle = "zdiff3";
      gpg.program = "gpg";
    };
    signing = {
      format = "openpgp";
      key = "44A046BE9D985980!";
      signByDefault = true;
    };
    delta = { enable = true; };
    aliases = {
      co = "checkout";
      create = "branch";
    };
  };
  gh = { enable = true; };
  zsh = import ./zsh args;
  eza = {
    enable = true;
    git = true;
    icons = "auto";
  };
  fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultOptions = [ "--height 40%" "--layout reverse" "--border top" ];
    tmux = {
      enableShellIntegration = true;
      shellIntegrationOptions = [ "--bottom,40%" ];
    };
  };
  starship = import ./starship;
  tmux = import ./tmux args;
  nixvim = import ./nixvim args;
  ripgrep = { enable = true; };
  gpg = { enable = true; };
  password-store = { enable = true; };
}
