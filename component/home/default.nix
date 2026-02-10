{ pkgs, username, ... }: {
  xdg.configFile."tmux/notify.sh" = { source = ./tmux/notify.sh; };
  imports = [
    ./git.nix
    ./zsh
    ./starship
    ./tmux
    ./nixvim
    ./gpg.nix
    ./fzf.nix
    ./eza.nix
  ];
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
    ripgrep = { enable = true; };
    password-store = { enable = true; };
  };
}

