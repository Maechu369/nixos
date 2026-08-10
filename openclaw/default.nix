{ inputs, ... }:
let
  inherit (inputs)
    nixpkgs
    microvm
    ;
in
{
  flake.nixosConfigurations.openclaw = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      microvm.nixosModules.microvm
      ./config.nix
    ];
  };
}
