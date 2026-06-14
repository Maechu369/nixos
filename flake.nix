{
  description = "NixOS config";
  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs?ref=release-25.05";
    nixpkgs.url = "github:nixos/nixpkgs/9ae611a455b90cf061d8f332b977e387bda8e1ca";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    xremap = {
      url = "github:xremap/nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-hardware,
      home-manager,
      sops-nix,
      plasma-manager,
      xremap,
      nixvim,
      ...
    }:
    let
      username = "hiroki";
    in
    {
      nixosConfigurations.mypc = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit username nixos-hardware xremap; };
        modules = [
          ./mypc/config.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              backupFileExtension = "backup";
              useGlobalPkgs = true;
              useUserPackages = true;
              sharedModules = [
                nixvim.homeModules.nixvim
                plasma-manager.homeModules.plasma-manager
                sops-nix.homeManagerModules.sops
              ];
              extraSpecialArgs = { inherit username xremap; };
              users."${username}" = ./mypc/home.nix;
            };
          }
          sops-nix.nixosModules.sops
        ];
      };
      nixosConfigurations.letsnote = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit username nixos-hardware xremap; };
        modules = [
          ./letsnote/config.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              backupFileExtension = "backup";
              useGlobalPkgs = true;
              useUserPackages = true;
              sharedModules = [
                nixvim.homeModules.nixvim
                plasma-manager.homeModules.plasma-manager
                sops-nix.homeManagerModules.sops
              ];
              extraSpecialArgs = { inherit username xremap; };
              users."${username}" = ./letsnote/home.nix;
            };
          }
          sops-nix.nixosModules.sops
        ];
      };
      nixosConfigurations.iso = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit username; };
        modules = [
          ./iso/configuration.nix
        ];
      };
      nixosConfigurations.minimum = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit username nixos-hardware xremap; };
        modules = [
          ./minimum/minimum.nix
        ];
      };
    };
}
