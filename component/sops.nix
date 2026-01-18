{ ... }:
let ageKeyFile = "/var/lib/sops-nix/keys.txt";
in {
  sops = {
    age.keyFile = ageKeyFile;
    age.generateKey = true;
    defaultSopsFile = ../secrets/secret.yaml;
    defaultSopsFormat = "yaml";
    secrets.hashedPassword.neededForUsers = true;
  };
  environment.variables = { SOPS_AGE_KEY_FILE = ageKeyFile; };
}
