{ inputs, ... }:
{
  containers."searxng".config = inputs.sops-nix.nixosModules.sops;
}
