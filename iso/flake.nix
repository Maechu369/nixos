{
  description = "Minimal NixOS installation media";
  inputs = {
    nixpkgs-pin.url = "path:../pkgs";
    nixpkgs.follows = "nixpkgs-pin/nixpkgs";
  };
  outputs = { self, nixpkgs }: {
    nixosConfigurations = {
      exampleIso = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./configuration.nix ];
      };
    };
  };
}
