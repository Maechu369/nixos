{
  description = "NixOS config";
  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs?ref=release-25.05";
    nixpkgs.url = "github:nixos/nixpkgs/29e290002bfff26af1db6f64d070698019460302";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {self, nixpkgs, home-manager, sops-nix, ...}@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./config.nix
        home-manager.nixosModules.home-manager {
          home-manager.backupFileExtension = "backup";
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.hiroki = import ./home.nix;
        }
        sops-nix.nixosModules.sops
      ];
    };
  };
}
