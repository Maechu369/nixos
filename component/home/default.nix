{
  pkgs,
  username,
  config,
  ...
}:
{
  xdg.enable = true;
  xdg.configFile."tmux/notify.sh" = {
    source = ./tmux/notify.sh;
  };
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
      fastfetch
      fd
      libgcc
      libinput
      usbutils
      pciutils
      trash-cli
      hydra-check
      nixfmt
      ripgrep
      nmon
      pinentry-qt
      unixtools.xxd
      qrrs
      nmap
      dig
      python313Packages.python
      python313Packages.numpy
      python313Packages.matplotlib
      bat
      emacs
      sc-im
      systemd-manager-tui
      tea
    ];
  };
  programs = {
    home-manager.enable = true;
    delta = {
      enable = true;
    };
    ripgrep = {
      enable = true;
    };
    password-store = {
      enable = true;
      settings.PASSWORD_STORE_DIR = "${config.xdg.dataHome}/password-store";
    };
  };
}
