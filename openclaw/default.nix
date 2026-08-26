{ inputs, ... }:
let
  inherit (inputs)
    nixpkgs
    microvm
    home-manager
    ;
in
{
  flake.nixosConfigurations.openclaw = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      microvm.nixosModules.microvm
      ./config.nix
      home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          sharedModules = [
          ];
          users."root" = ./home.nix;
        };
      }
    ];
  };
}
