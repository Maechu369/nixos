# openclaw

MicroVM (microvm.nix) 上で動作するOpenclawホスト. mypc 上では `mypc/default.nix` の `microvm.vms.openclaw.flake = self` で起動し、`mypc/containers/openclaw.nix` が `openclaw.home.arpa` をリバースプロキシする.

- `default.nix` — flake出力 (`microvm.nixosModules.microvm` + home-manager)
- `config.nix` — MicroVM構成のNixOS設定
- `home.nix` — rootユーザーのHome Manager設定
- `openclaw.nix` — `pkgs.openclaw` のビルド調整 (overrideAttrs)
