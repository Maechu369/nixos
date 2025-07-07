{config, pkgs, ...}:

{
  home.username = "hiroki";
  home.homeDirectory = "/home/hiroki";
  home.stateVersion = "25.05";
  home.packages = with pkgs; [
  ];
  programs = {
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
    };
  };
}
