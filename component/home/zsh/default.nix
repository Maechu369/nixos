{ lib, config, ... }: {
  enable = true;
  defaultKeymap = "emacs";
  dotDir = "${config.xdg.configHome}/zsh";
  autocd = true;
  autosuggestion.enable = true;
  dirHashes = {
    c = "/mnt/c";
    wh = "/mnt/c/Users/$USER";
  };
  history = {
    ignoreAllDups = true;
    ignoreSpace = true;
  };
  profileExtra = "test -f $HOME/.profile && . $HOME/.profile";
  sessionVariables = {
    TERM = "xterm-256color";
    EZA_ICON_SPACING = 1;
    PYTHONCACHEPREFIX = "/tmp";
  };
  initContent = let
    zshMkBefore = lib.mkOrder 500 (builtins.readFile ./zshMkBefore.zsh);
    zshDefault = lib.mkOrder 1000 (builtins.readFile ./zshDefault.zsh);
  in lib.mkMerge [ zshMkBefore zshDefault ];
  shellAliases = {
    "..." = "cd ../..";
    "...." = "cd ../../..";
    zmv = "noglob zmv -W";
    q = "exit";
    c = "cd";
    rm = "trash";
    remove = "command rm";
    tmux = "tmux new -A";
    v = "vim";
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
    compose = "docker compose";
  };
}
