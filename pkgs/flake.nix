{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url =
      "github:nixos/nixpkgs/0590cd39f728e129122770c029970378a79d076a";
  };

  outputs = { self, nixpkgs, ... }: {
    inherit nixpkgs;
    legscyPackages = nixpkgs.legscyPackages;
  };
}
