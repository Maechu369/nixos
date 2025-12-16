{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url =
      "github:nixos/nixpkgs/c8cfcd6ccd422e41cc631a0b73ed4d5a925c393d";
  };

  outputs = { self, nixpkgs, ... }: {
    inherit nixpkgs;
    legscyPackages = nixpkgs.legscyPackages;
  };
}
