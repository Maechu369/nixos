# NixOS Configs

自分用のNix環境用リポジトリ。

`flake-parts` ベースのflake構成で、複数マシン間で共通モジュールを共有する。

## ホスト一覧

| ホスト | 概要 | 特徴 |
|--------|------|------|
| `mypc` | メイン環境 (デスクトップ) | AMD CPU, NVIDIA GPU, ZFS, KDE Plasma 6 |
| `letsnote` | ノートPC | Intel CPU, KDE Plasma 6 |
| `openclaw` | MicroVMホスト (Openclaw) | microvm.nix. mypc 上で `microvm.vms.openclaw` として起動 |
| `iso` | インストールISOイメージ | 最小構成 |
| `minimum` | 最小限のデスクトップ | KDE Plasma 5, 検証用 |

## 設計方針

- `component/` — 共有モジュール. `mypc` と `letsnote` が `config.nix` から `../component` (= `component/default.nix`) を導入し、必要な `component/*.nix` を個別import. `iso` / `minimum` / `openclaw` は component をimportしない独立設定
- `component/desktop/` — デスクトップ環境関連. デスクトップhostでのみimport
- `component/home/` — home-managerの共有モジュール群 (mypc / letsnote の `home.nix` が import)
- `mypc/*.nix` / `letsnote/*.nix` — 各ホスト固有の設定
- `mypc/containers/` — NixOSコンテナ (gitea, searxng, files) と各サービスの nginx virtualHost (ACME) + NAT. `mypc/containers/openclaw.nix` はコンテナではなく openclaw MicroVM へのリバースプロキシ
- `openclaw/` — MicroVMホスト

flake inputsのうち用途が名前から分からないもの: `microvm` (MicroVM仮想化), `oh-my-pi` (ompコーディングエージェントのhome-managerモジュール), `xremap` (キーリマップ).

## 使い方

### 通常の更新

```bash
sudo nixos-rebuild switch
```

ホスト名 (`networking.hostName`) に対応する設定が自動選択される。

### パッケージ更新

`flake.nix`の`inputs.nixpkgs.url`を手動で更新する。ハッシュは`hydra-check`を使用し、手動で選択する。

### 明示的にホストを指定

```bash
sudo nixos-rebuild switch --flake .#mypc
sudo nixos-rebuild switch --flake .#letsnote
```

### ISOイメージのビルド

`nix build .#nixosConfigurations.iso.config.system.build.isoImage` (または `./build-iso.sh`). 書き込み手順は [iso/README.md](iso/README.md) 参照.

### 開発 (direnv)

`.envrc` によりdirenvでflake devShellが自動ロードされる。
pre-commit (nixfmt + git-secrets) が有効になる。

```bash
direnv allow
```

## シークレット管理

[sops-nix](https://github.com/Mic92/sops-nix) を使用。
age鍵で暗号化された `secrets/secret.yaml` にハッシュ化パスワード等を保管。
