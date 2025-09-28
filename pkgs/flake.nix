{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url =
      "github:nixos/nixpkgs/e643668fd71b949c53f8626614b21ff71a07379d";
  };

  outputs = { self, nixpkgs, ... }: {
    inherit nixpkgs;
    legscyPackages = nixpkgs.legscyPackages;
  };
}
