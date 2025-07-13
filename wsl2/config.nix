{ config, lib, pkgs, ... }: {
  imports = [
  ];
  nix.settings.experimental-features = ["nix-command" "flakes"];

  wsl.enable = true;
  wsl.defaultUser = "nixos";

  time.timeZone = "Asia/Tokyo";

  # sops = {
  #   defaultSopsFile = ../secrets/default.yaml;
  # };

  users.users.nixos = {
    isNormalUser = true;
    description = "nixos";
    hashedPassword = "$6$i2rCjc.WYLu4Cn8/$WoI36Fn3t/qnzWYrckb7n56Jo/Fm9D1jbCzw3Lg7pNrkEWNQYpeV1uAoZU9BJHnYizg5vubGhgKlHka8baSMW1";
    extraGroups = [ "networkmanager" "wheel" ];
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILv9JtMAq/KexNVaWmvyh7ouppoA0aDPO8qxlnYUQDtq nixos@nixos" ];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
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
  environment.systemPackages = with pkgs;[
  ];

  services.openssh.enable = true;
}
