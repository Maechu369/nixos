{
  description = "flake";
  inputs = {
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nixpkgs.url = "github:nixos/nixpkgs/29e290002bfff26af1db6f64d070698019460302";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # agenix.url = "github:yaxitech/ragenix";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nixos-wsl, sops-nix, nixvim, ... }@inputs:
  {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
	nixos-wsl.nixosModules.default {
	    system.stateVersion = "24.11";
	    wsl.enable = true;
	}
        home-manager.nixosModules.home-manager {
	  home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
	    sharedModules = [
	      nixvim.homeModules.nixvim
	    ];
            users.hiroki = import ./home.nix;
	  };
        }
	sops-nix.nixosModules.sops
	./config.nix
      ];
    };
  };
}
