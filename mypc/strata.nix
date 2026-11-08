{ stdenv, fetchFromGitHub, ... }:
let
  version = "v0.2.12";
  strata = fetchFromGitHub {
    owner = "Niko1221";
    repo = "Strata";
    rev = version;
    hash = "sha256-iMjGRmrr2luO7O0x5QF4iIWpOVRQp1mlSeTWFDGZEVo=";
  };
in
stdenv.mkDerivation {
  name = "strata";
  inherit version;
  src = strata;

  buildPhase = ''
    set -euo pipefail
    mkdir -p $out/bin
    cat > $out/bin/strata <<EOF
    #!/bin/sh
    work="\$HOME/.local/share/strata-src"
    [ -e "\$work/flake.nix" ] || { mkdir -p "\$work"; cp -rf ${strata}/. "\$work"/; }
    cd "\$work"
    chmod +w "\$work/third_party"
    exec nix develop --impure -c ./setup.sh "\$@"
    EOF
    chmod +x $out/bin/strata
  '';
}
