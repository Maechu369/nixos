{ lib, config, ... }: {
  programs.zsh = {
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
    initContent =
      let
        zshMkBefore = lib.mkOrder 500 (builtins.readFile ./zshMkBefore.zsh);
        zshDefault = lib.mkOrder 1000 (builtins.readFile ./zshDefault.zsh);
      in
      lib.mkMerge [
        zshMkBefore
        zshDefault
      ];
    shellAliases = {
      "..." = "cd ../..";
      "...." = "cd ../../..";
      zmv = "noglob zmv -W";
      q = "exit";
      c = "cd";
      remove = "command rm";
      # 外部コマンド前提のalias(ls/eza, diff/delta, rm=trash, v=vim, python,
      # pc=procs, sys, te, compose, tmux, lsblk)はzshDefault.zsh側でcommand -vガード付きで定義
      gt = "cd `git rev-parse --show-toplevel`";
      gs = "git status";
      gl = "git log --all --graph";
      clean = "git clean -ifd";
      commit = "git commit -m";
      l = "ls";
    };
  };
}
