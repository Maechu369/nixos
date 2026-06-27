{ ... }:
let
  nixbuild = "nixbuild";
in
{
  users = {
    users."${nixbuild}" = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "no-port-forwarding,no-X11-forwarding,no-agent-forwarding ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE6L0ZIKfm/iO9OEZOhe6qDTd5hcdJJG2QdRuXma86wa nixbuild@mypc"
      ];
    };
  };
}
