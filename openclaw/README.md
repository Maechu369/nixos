# openclaw

MicroVM上で動作するOpenclawホスト。

## ファイル

| ファイル | 説明 |
|----------|------|
| `config.nix` | OpenclawホストのNixOS設定（MicroVM構成） |
| `default.nix` | flake出力（microvm.nix + home-manager） |
| `openclaw.nix` | Openclawパッケージのビルド定義 |
| `home.nix` | ルートユーザーのHome Manager設定 |
