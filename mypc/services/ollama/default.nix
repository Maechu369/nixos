{ pkgs, ... }: {
  enable = true;
  package = pkgs.ollama-cuda;
  acceleration = "cuda";
}
