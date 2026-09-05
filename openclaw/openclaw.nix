{
  pkgs ? import <nixpkgs> { },
  ...
}:
let
  version = "2026.9.1";
  openclaw_version = "2026.9.1";

  # Prepare manually
  # because of reproducibility of pnpm (https://github.com/NixOS/nixpkgs/pull/522703)
  # $ nix-shell -p pnpm nodejs
  # $ vim package.json  # remove .packageManager
  # $ pnpm install --frozen-lockfile --store-dir=./pnpm-store
  # $ tar cavf openclaw-v${openclaw_version}.tar.zst node_modules pnpm-store
  openclaw_node_modules = builtins.fetchurl {
    url = "https://files.home.arpa/openclaw-v${openclaw_version}.tar.zst";
    sha256 = "sha256:1zfnjdrvc5pga483dkwsyyz2d0fh28sk9iyjdby81qjkvgarc630";
    name = "openclaw-node-modules";
  };
in
pkgs.openclaw.overrideAttrs (old: {
  version = version;
  src = pkgs.fetchFromGitHub {
    owner = "openclaw";
    repo = "openclaw";
    tag = "v${openclaw_version}";
    hash = "sha256-g7N+xotLQl0D+5vcBcAuNVyrPQNih9cDKJwwlC+4kBY=";
  };
  pnpmDeps = null;
  nativeBuildInputs = [
    pkgs.pnpm_11
    pkgs.nodejs-slim_22
    pkgs.makeWrapper
    pkgs.installShellFiles
    pkgs.zstd
    pkgs.jq
  ];
  postPatch = (old.postPatch or "") + ''
    jq '.packageManager = "pnpm@${pkgs.pnpm_11.version}"' package.json > package.json.tmp
    mv package.json.tmp package.json
    echo 'trustLockfile: true' >> pnpm-workspace.yaml
  '';
  postUnpack = ''
    tar xf ${openclaw_node_modules} -C source
    jq '.storeDir = "/build/pnpm-store"' source/node_modules/.modules.yaml \
      > source/node_modules/.modules.yaml.tmp
    mv source/node_modules/.modules.yaml.tmp source/node_modules/.modules.yaml
  '';
  buildPhase = ''
    runHook preBuild
    export CI=true
    export OPENCLAW_TSDOWN_MAX_OLD_SPACE_MB=4096
    export OPENCLAW_BUILD_TIMESTAMP="$(date -u -d @$SOURCE_DATE_EPOCH +'%Y-%m-%dT%H:%M:%S.000Z')"

    # Replace pnpm-installed rolldown with the Nix-built version
    rm -rf node_modules/rolldown node_modules/@rolldown/pluginutils
    mkdir -p node_modules/@rolldown node_modules/.pnpm/node_modules/@rolldown
    cp -r ${pkgs.rolldown}/lib/node_modules/rolldown node_modules/rolldown
    cp -r ${pkgs.rolldown}/lib/node_modules/@rolldown/pluginutils node_modules/@rolldown/pluginutils
    cp -r ${pkgs.rolldown}/lib/node_modules/rolldown node_modules/.pnpm/node_modules/rolldown
    cp -r ${pkgs.rolldown}/lib/node_modules/@rolldown/pluginutils node_modules/.pnpm/node_modules/@rolldown/pluginutils
    chmod -R u+w node_modules/rolldown node_modules/@rolldown/pluginutils \
      node_modules/.pnpm/node_modules/rolldown node_modules/.pnpm/node_modules/@rolldown/pluginutils

    pnpm install --offline --frozen-lockfile --store-dir $PWD/pnpm-store
    export OPENCLAW_BUILD_ALL_NO_PNPM=1
    pnpm build
    pnpm ui:build
    runHook postBuild
  '';
  preInstall = ''
    libdir=$out/lib/openclaw
    mkdir -p $libdir
    cp --reflink=auto -r packages openclaw.mjs examples $libdir/
  '';
})
