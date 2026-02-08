{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url =
      "github:nixos/nixpkgs/23d72dabcb3b12469f57b37170fcbc1789bd7457";
  };

  outputs = { self, nixpkgs, ... }: {
    inherit nixpkgs;
    legscyPackages = nixpkgs.legscyPackages;
  };
}
