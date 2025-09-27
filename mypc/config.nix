# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

args@{ config, lib, pkgs, username, nixos-hardware, xremap, ... }: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./extra-hardware-configuration.nix
    nixos-hardware.nixosModules.common-cpu-amd
    nixos-hardware.nixosModules.common-pc-ssd
    ./gpu.nix
    xremap.nixosModules.default

    ../component/locale.nix
    ../component/sops.nix
    ../component/users.nix
    ../component/desktop
    ../component/desktop/steam.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 32;

  boot.kernelPackages = pkgs.linuxPackages;
  boot.extraModulePackages = with config.boot.kernelPackages; [ rtl8852au ];
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [ ];

  programs.zsh.enable = true;

  virtualisation.docker = { enable = true; };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  systemd.services.NetworkManager-wait-online = {
    serviceConfig = {
      ExecStart = [ "" "${pkgs.networkmanager}/bin/nm-online -q --timeout=30" ];
    };
  };
  services = {
    openssh = import ../component/services/openssh;
    xremap = import ../component/services/xremap username;
    clamav = import ../component/services/clamav args;
    open-webui = import services/open-webui args;
    ollama = import services/ollama args;
  };
  systemd.timers."clamav-fullscan" = {
    enable = true;
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "monthly";
      Persistent = true;
      Unit = "clamav-fullscan.service";
      RandomizedDelaySec = 3600;
    };
  };
  systemd.services."clamav-fullscan" = {
    enable = true;
    wants = [ "clamav-daemon.service" ];
    after = [ "clamav-daemon.service" ];
    script = ''
      set -euo pipefail
      mkdir -p /var/log/clamav
      chown clamav:clamav /var/log/clamav
      ${pkgs.clamav}/bin/clamdscan -m --fdpass --log=/var/log/clamav/scan.log --exclude-dir="/sys" --exclude-dir="/proc" --exclude-dir="/dev" --exclude-dir="/run" --exclude-dir="/tmp" --exclude-dir="/nix/store" --exclude-dir="/nix/var" --infected --recursive /
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
      StandardOutput = "journal";
      StandardError = "journal";
      CPUQuota = "50%";
      MemoryMax = "4G";
    };
  };

  # Open ports in the firewall.
  networking.nftables.enable = true;
  networking.firewall = {
    enable = true;
    # allowedTCPPorts = [ ... ];
    # allowedUDPPorts = [ ... ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
