{ ... }:
{
  fileSystems."/nix/build" = {
    device = "tmpfs";
    fsType = "tmpfs";
    options = [
      "size=16G"
      "mode=755"
    ];
  };

  nix.settings = {
    build-dir = "/nix/build";
  };
}
