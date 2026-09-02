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
├── flake.nix
├── .envrc
├── .sops.yaml
├── build-iso.sh
├── secrets-patterns.txt
│
├── mypc/                         # デスクトップPC (ホスト固有設定)
│   ├── config.nix
│   ├── default.nix
│   ├── hardware-configuration.nix
│   ├── extra-hardware-configuration.nix
│   ├── home.nix
│   ├── gpu.nix
│   ├── tpm.nix
│   ├── dns.nix
│   ├── acme.nix
│   ├── backup.nix
│   ├── build.nix
│   ├── nixbuild-host.nix
│   ├── tailscale.nix
│   ├── samba.nix
│   ├── wol.nix
│   ├── nginx.nix
│   ├── omp.nix
│   ├── nixvim.nix
│   ├── plasma.nix
│   ├── opencode/
│   │   ├── default.nix
│   │   └── opencode.json
│   └── containers/
│       ├── default.nix
│       ├── openclaw.nix
│       ├── llama/
│       │   ├── default.nix
│       │   └── llama.nix
│       ├── searxng/
│       │   ├── default.nix
│       │   └── searxng.nix
│       └── gitea/
│           ├── default.nix
│           └── gitea.nix
│
├── letsnote/                     # ノートPC (ホスト固有設定)
│   ├── config.nix
│   ├── default.nix
│   ├── hardware-configuration.nix
│   ├── extra-hardware-configuration.nix
│   ├── home.nix
│   ├── tpm.nix
│   ├── dns.nix
│   └── tailscale.nix
│
├── iso/                          # ISOイメージ
│   ├── configuration.nix
│   └── default.nix
│
├── minimum/                      # 最小構成 (KDE Plasma 5)
│   ├── default.nix
│   └── minimum.nix
│
├── openclaw/                     # MicroVMホスト
│   ├── config.nix
│   ├── default.nix
│   ├── openclaw.nix
│   └── home.nix
│
└── component/                    # 共有モジュール
    ├── default.nix
    ├── ca-root.nix
    ├── sops.nix
    ├── users.nix
    ├── kernel.nix
    ├── locale.nix
    ├── networking.nix
    ├── nixbuild.nix
    ├── docker.nix
    ├── experimental.nix
    ├── unfree.nix
    ├── system-packages.nix
    ├── bootloader.nix
    ├── openssh.nix
    ├── clamav.nix
    ├── printer.nix
    ├── root_ca.crt
    ├── desktop/
    │   ├── default.nix
    │   ├── displayManager.nix
    │   ├── input.nix
    │   ├── sound.nix
    │   └── steam.nix
    └── home/
        ├── default.nix
        ├── git.nix
        ├── gpg.nix
        ├── eza.nix
        ├── fzf.nix
        ├── bin/
        │   └── color
        ├── kxkbrc
        ├── kwinrc
        ├── desktop/
        │   ├── default.nix
        │   ├── firefox.nix
        │   ├── kitty.nix
        │   ├── thunderbird.nix
        │   ├── vscode.nix
        │   ├── plasma.nix
        │   ├── xremap.nix
        │   ├── libskk/
        │   │   └── README.rules
        │   └── fcitx5/
        │       ├── config
        │       └── profile
        ├── nixvim/
        │   ├── default.nix
        │   ├── pre.lua
        │   └── init.lua
        ├── starship/
        │   ├── default.nix
        │   └── starship.toml
        ├── tmux/
        │   ├── default.nix
        │   ├── tmux.conf
        │   └── notify.sh
        └── zsh/
            ├── default.nix
            ├── zshDefault.zsh
            └── zshMkBefore.zsh
```

### 設計方針

- `component/default.nix` — 全ホストに必ず導入するモジュールの集約
- `component/*.nix` — 共有モジュール (optional). 必要なhostのconfig.nixで個別import
- `component/desktop/` — デスクトップ環境関連. デスクトップhostでのみimport
- `component/home/` — home-managerの共有モジュール群
- `mypc/*.nix` / `letsnote/*.nix` — 各ホスト固有の設定
- `mypc/containers/` — NixOSコンテナ (llama, searxng, gitea, openclaw)

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
| [microvm](https://github.com/microvm-nix/microvm.nix) | MicroVM仮想化 |
| [oh-my-pi](https://github.com/can1357/oh-my-pi) | Raspberry Pi/ARM NixOS対応 |
