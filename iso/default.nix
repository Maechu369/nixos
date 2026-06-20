{ inputs, username, ... }:
let
  inherit (inputs)
    nixpkgs
    ;
in
{
  flake.nixosConfigurations.iso = nixpkgs.lib.nixosSystem {
    specialArgs = { inherit username; };
    modules = [
      ./configuration.nix
    ];
  };
}
