{ pkgs, config, username, ... }: {
  users = {
    users."${username}" = {
      isNormalUser = true;
      description = username;
      hashedPasswordFile = config.sops.secrets.hashedPassword.path;
      extraGroups = [ "networkmanager" "wheel" "docker" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFbkbVhapmW864se06Wk+IWzm5XmfsP0nohg0MVX9b1i openpgp:0x67DC50BF"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOLR3JlwwfoQ6epSxsqTTCVdN61xZqo3C4YFkxHDQ4eT u0_a242@localhost"
      ];
      shell = pkgs.zsh;
      packages = with pkgs; [ kdePackages.kate ];
    };
    mutableUsers = false;
  };
}
