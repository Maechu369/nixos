{
  pkgs ? import <nixpkgs> { },
  ...
}:
pkgs.openclaw.overrideAttrs (old: {
  env.OPENCLAW_TSDOWN_MAX_OLD_SPACE_MB = "8192";
  env.CI = true;
  preBuild = ''
    export OPENCLAW_BUILD_TIMESTAMP="$(date -u -d @$SOURCE_DATE_EPOCH +'%Y-%m-%dT%H:%M:%S.000Z')"
  '';
})
