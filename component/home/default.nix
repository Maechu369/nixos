args@{ pkgs, username, ... }: {
  xdg.configFile."tmux/notify.sh" = { source = ./tmux/notify.sh; };
  imports = [ ./git.nix ];
  home = {
    homeDirectory = "/home/${username}";
    stateVersion = "25.05";
    file = {
      "bin" = {
        source = ./bin;
        recursive = true;
      };
    };
    packages = with pkgs; [
      procs
      neofetch
      fd
      libgcc
      libinput
      usbutils
      pciutils
      trash-cli
      hydra-check
      nixfmt-classic
      ripgrep
      nmon
      pinentry-qt
      unixtools.xxd
      qrrs
      nmap
      python313Packages.python
      python313Packages.numpy
      python313Packages.matplotlib
      bat
      emacs
    ];
  };
  programs = {
    home-manager.enable = true;
    delta = { enable = true; };
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
  };
  services = import ./services args;
}

