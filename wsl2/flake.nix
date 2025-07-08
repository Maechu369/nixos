{
  description = "flake";

  inputs = {
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, nixos-wsl, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
	nixos-wsl.nixosModules.default
	  {
	    system.stateVersion = "24.11";
	    wsl.enable = true;
	  }
      ];
    };
  };
}
