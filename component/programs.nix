{lib, ...}:
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
  zsh = {
    enable = true;
    dotDir = ".config/zsh";
    autocd = true;
    autosuggestion.enable = true;
    cdpath = ["~" ".."];
    dirHashes = {
      c = "/mnt/c";
      wh = "/mnt/c/Users/hiroki";
    };
    history = {
      ignoreAllDups = true;
      ignoreSpace = true;
    };
    profileExtra = "test -f $HOME/.profile && . $HOME/.profile";
    sessionVariables = {
      TERM = "xterm-256color";
      EDITOR = "nvim";
      EZA_ICON_SPACING = 1;
    };
    initContent = "";
    shellAliases = {
      "..." = "cd ../..";
      "...." = "cd ../../..";
      zmv = "noglob zmv -W";
      q = "exit";
      c = "cd";
      v = "vim";
      vim = "nvim";
      python = "python3";
      py = "python";
      l = "ls";
      ls = "eza -F";
      la = "eza -aF";
      ll = "eza -aahlF";
      lt = "eza -aT -L 3 -I '.git|.cache'";
      diff = "delta";
      diffs = "DELTA_FEATURES=+side-by-side delta";
      gt = "cd `git rev-parse --show-toplevel`";
      gs = "git status";
      gl = "git log --all --graph";
      gitc = "git checkout";
      gls = "git ls-files";
      clean = "git clean -ifd";
      commit = "git commit -m";
      pc = "procs --tree";
      lsblk = "lsblk -ipo +UUID";
    };
  };
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
