{ ... }:
{
  sops.secrets."nixbuild.env" = {
    format = "binary";
    sopsFile = ../secrets/nixbuild.enc;
    path = "/root/.ssh/id_ed25519";
    owner = "root";
    mode = "0600";
  };
}
