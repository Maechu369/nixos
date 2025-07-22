{ config, lib, pkgs, ... }:
let ageKeyFile = "/var/lib/sops-nix/keys.txt";
in {
  imports = [ ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  wsl.enable = true;
  wsl.defaultUser = "hiroki";

  time.timeZone = "Asia/Tokyo";

  sops = {
    age.keyFile = ageKeyFile;
    age.generateKey = true;
    defaultSopsFile = ../secrets/secret.yaml;
    defaultSopsFormat = "yaml";
    secrets.hashedPassword.neededForUsers = true;
  };

  users.users.hiroki = {
    isNormalUser = true;
    description = "hiroki";
    hashedPasswordFile = config.sops.secrets.hashedPassword.path;
    extraGroups = [ "networkmanager" "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILv9JtMAq/KexNVaWmvyh7ouppoA0aDPO8qxlnYUQDtq hiroki@nixos"
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [ kdePackages.kate ];
  };
  users.mutableUsers = false;
  security.sudo.wheelNeedsPassword = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
  environment.systemPackages = with pkgs; [ ];
  environment.variables = { SOPS_AGE_KEY_FILE = ageKeyFile; };
  programs.zsh.enable = true;

  services.openssh.enable = true;
}
