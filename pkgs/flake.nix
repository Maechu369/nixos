{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url =
      "github:nixos/nixpkgs/c5ae371f1a6a7fd27823bc500d9390b38c05fa55";
  };

  outputs = { self, nixpkgs, ... }: {
    inherit nixpkgs;
    legscyPackages = nixpkgs.legscyPackages;
  };
}
