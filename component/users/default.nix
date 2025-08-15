{ pkgs, config, username, ... }: {
  users."${username}" = {
    isNormalUser = true;
    description = username;
    hashedPasswordFile = config.sops.secrets.hashedPassword.path;
    extraGroups = [ "networkmanager" "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFbkbVhapmW864se06Wk+IWzm5XmfsP0nohg0MVX9b1i openpgp:0x67DC50BF"
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [ kdePackages.kate ];
  };
  mutableUsers = false;
}
