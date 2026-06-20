{ inputs, username, ... }:
let
  inherit (inputs)
    nixpkgs
    nixos-hardware
    home-manager
    sops-nix
    plasma-manager
    xremap
    nixvim
    ;
in
{
  flake.nixosConfigurations.mypc = nixpkgs.lib.nixosSystem {
    specialArgs = { inherit username nixos-hardware xremap; };
    modules = [
      ./config.nix
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
          users."${username}" = ./home.nix;
        };
      }
      sops-nix.nixosModules.sops
    ];
  };
}
