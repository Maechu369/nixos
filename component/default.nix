{ ... }: {
  imports = [
    ./experimental.nix
    ./bootloader.nix
    ./kernel.nix
    ./networking.nix
    ./printer.nix
    ./locale.nix
    ./unfree.nix
    ./sops.nix
    ./system-packages.nix
    ./docker.nix
    ./users.nix
  ];
}
