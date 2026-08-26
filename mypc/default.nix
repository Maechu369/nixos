{
  self,
  inputs,
  username,
  ...
}:
let
  inherit (inputs)
    nixpkgs
    nixos-hardware
    home-manager
    sops-nix
    plasma-manager
    xremap
    nixvim
    microvm
    oh-my-pi
    ;
in
{
  flake.nixosConfigurations.mypc = nixpkgs.lib.nixosSystem {
    specialArgs = { inherit username nixos-hardware xremap; };
    modules = [
      ./config.nix
      microvm.nixosModules.host
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
            oh-my-pi.homeManagerModules.default
          ];
          extraSpecialArgs = { inherit username xremap; };
          users."${username}" = ./home.nix;
        };
      }
      {
        microvm.vms."openclaw".flake = self;
      }
      sops-nix.nixosModules.sops
    ];
  };
}
