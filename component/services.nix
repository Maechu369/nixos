{ pkgs, ... }: {
  gpg-agent = {
    enable = true;
    enableZshIntegration = true;
    enableSshSupport = true;
    sshKeys = ["E3CF33B999D9A0855494F5D034AEE94E4E1D4A2D"];
    pinentry = {
      package = pkgs.pinentry-qt;
      program = "pinentry";
    };
  };
}
