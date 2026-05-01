{ pkgs, ... }:
{
  programs.kitty = {
    enable = true;
    font = {
      package = pkgs.plemoljp-nf;
      size = 11.0;
      name = "Plemoljp NF";
    };
  };
}
