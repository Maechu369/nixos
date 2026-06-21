# NixOS Configs

自分用のNix環境用リポジトリ。

`flake-parts` ベースのflake構成で、複数マシン間で共通モジュールを共有する。

## ホスト一覧

| ホスト | 概要 | 特徴 |
|--------|------|------|
| `mypc` | メイン環境 (デスクトップ) | AMD CPU, NVIDIA GPU, ZFS, KDE Plasma 6 |
| `letsnote` | ノートPC | Intel CPU, KDE Plasma 6 |
| `iso` | インストールISOイメージ | 最小構成 |
| `minimum` | 最小限のデスクトップ | KDE Plasma 5, 検証用 |

## ディレクトリ構成

```
.
├── flake.nix                     # エントリーポイント
├── .envrc                        # direnv (use flake)
├── .sops.yaml                    # SOPS age鍵設定
├── build-iso.sh                  # ISOビルド用スクリプト
├── secrets-patterns.txt          # git-secrets スキャンパターン
│
├── mypc/                         # デスクトップPC (ホスト固有設定)
├── letsnote/                     # ノートPC (ホスト固有設定)
├── iso/                          # ISOイメージ
├── minimum/                      # 最小構成
│
└── component/                    # 共有モジュール
    ├── default.nix               # 全ホスト共通で必ず導入するモジュール
    ├── openssh.nix               # オプション (必要に応じて各hostでimport)
    ├── clamav.nix                # オプション
    │
    ├── desktop/                  # デスクトップ環境 (全デスクトップhostで導入)
    │   ├── default.nix
    │   ├── displayManager.nix    # SDDM + KDE Plasma 6
    │   ├── input.nix             # fcitx5, ydotool
    │   ├── sound.nix             # PipeWire
    │   └── steam.nix             # Steam
    │
    └── home/                     # home-manager 共有モジュール
        ├── default.nix           # 共通homeモジュール (git, zsh, tmux, nixvim, ...)
        ├── desktop/              # デスクトップ用homeモジュール
        │   ├── default.nix
        │   ├── alacritty.nix
        │   ├── kitty.nix
        │   ├── firefox.nix
        │   ├── thunderbird.nix
        │   ├── vscode.nix
        │   ├── plasma.nix
        │   └── xremap.nix
        ├── nixvim/               # Neovim設定
        ├── starship/             # Starship prompt
        ├── tmux/                 # tmux設定
        └── zsh/                  # Zsh設定
```

### 設計方針

- `component/default.nix` — 全ホストに必ず導入するモジュールの集約
- `component/*.nix` — 共有モジュール (optional). 必要なhostのconfig.nixで個別import
- `component/desktop/` — デスクトップ環境関連. デスクトップhostでのみimport
- `component/home/` — home-managerの共有モジュール群
- `mypc/*.nix` / `letsnote/*.nix` — 各ホスト固有の設定

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

```bash
nix build .#nixosConfigurations.iso.config.system.build.isoImage
# または
./build-iso.sh
```

### 開発 (direnv)

`.envrc` によりdirenvでflake devShellが自動ロードされる。
pre-commit (nixfmt + git-secrets) が有効になる。

```bash
direnv allow
```

## シークレット管理

[sops-nix](https://github.com/Mic92/sops-nix) を使用。
age鍵で暗号化された `secrets/secret.yaml` にハッシュ化パスワード等を保管。

## 使用しているflake inputs

| Input | 用途 |
|-------|------|
| [nixpkgs](https://github.com/NixOS/nixpkgs) | unstableを使用、手動更新 |
| [nixos-hardware](https://github.com/NixOS/nixos-hardware) | CPU/SSDハードウェアプロファイル |
| [home-manager](https://github.com/nix-community/home-manager) | ユーザー環境管理 |
| [flake-parts](https://github.com/hercules-ci/flake-parts) | flakeモジュール化 |
| [sops-nix](https://github.com/Mic92/sops-nix) | シークレット管理 |
| [plasma-manager](https://github.com/nix-community/plasma-manager) | KDE Plasma宣言的設定 |
| [nixvim](https://github.com/nix-community/nixvim) | Neovim宣言的設定 |
| [xremap](https://github.com/xremap/nix-flake) | キーリマップ |
| [git-hooks.nix](https://github.com/cachix/git-hooks.nix) | pre-commitフック |
