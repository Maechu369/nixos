# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, username, nixos-hardware, xremap, ... }: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./extra-hardware-configuration.nix
    nixos-hardware.nixosModules.common-cpu-intel
    nixos-hardware.nixosModules.common-cpu-intel
    nixos-hardware.nixosModules.common-pc-ssd

    ../component/experimental.nix
    ../component/bootloader.nix
    ../component/kernel.nix
    ../component/networking.nix
    ../component/printer.nix
    ../component/locale.nix
    ../component/unfree.nix
    ../component/sops.nix
    ../component/system-packages.nix
    ../component/docker.nix
    ../component/users.nix
    ../component/desktop
    ../component/desktop/sound.nix
    ../component/desktop/steam.nix
    ../component/openssh.nix
    ../component/clamav.nix
  ];

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
