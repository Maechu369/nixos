{ pkgs, ... }: {
  gpg-agent = {
    enable = true;
    pinentry = {
      package = pkgs.pinentry-qt;
      program = "pinentry";
    };
  };
}
