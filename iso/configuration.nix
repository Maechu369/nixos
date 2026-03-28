# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# see https://github.com/nix-community/nixos-generators

{
  username,
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  # imports = [ "${modulesPath}/installer/cd-dvd/installation-cd-graphical-plasma5.nix" ];
  # imports = [ "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix" ];
  imports = [ "${modulesPath}/installer/cd-dvd/installation-cd-base.nix" ];

  # Select Linux Kernel
  boot.kernelPackages = pkgs.linuxPackages;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  time.timeZone = "Asia/Tokyo";
  networking.hostName = "nixos";

  users.users."${username}" = {
    isNormalUser = true;
    home = "/home/${username}";
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGo2UZSbmkdNzJO+0znvrMMsp5LcWAF0h+c8e9Rw92jS ${username}@DESKTOP-QKM8RGF"
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
  system.stateVersion = "25.11"; # Did you read the comment?
  environment.systemPackages = with pkgs; [
    git
    networkmanager
  ];

  systemd.services.wpa_supplicant.wantedBy = lib.mkForce ["multi-user.target"];
  systemd.services.sshd.wantedBy = lib.mkForce ["multi-user.target"];

  environment.etc.recommend-config = {
    source = ./..;
    mode = "0666";
  };
}
