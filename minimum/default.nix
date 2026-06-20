{ inputs, username, ... }:
let
  inherit (inputs)
    nixpkgs
    nixos-hardware
    xremap
    ;
in
{
  flake.nixosConfigurations.minimum = nixpkgs.lib.nixosSystem {
    specialArgs = { inherit username nixos-hardware xremap; };
    modules = [
      ./minimum.nix
    ];
  };
}
