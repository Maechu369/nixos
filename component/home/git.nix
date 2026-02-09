{ pkgs, ... }: {
  programs.git = {
    enable = true;
    signing = {
      format = "openpgp";
      key = "44A046BE9D985980!";
      signByDefault = true;
    };
    settings = {
      alias = {
        co = "checkout";
        sw = "switch";
        re = "restore";
      };
      user.name = "Maechu369";
      user.email = "m6a7e0d8a3@gmail.com";
      core = { quotepath = false; };
      pull.rebase = "false";
      merge.conflictStyle = "zdiff3";
      gpg.program = "gpg";
    };
  };
  programs.gh = { enable = true; };
}
