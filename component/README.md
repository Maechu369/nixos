# component

全ホスト共通で利用する共有モジュール。

## ファイル一覧

| ファイル | 説明 |
|----------|------|
| `default.nix` | 全ホスト共通で必ず導入するモジュールの集約 |
| `ca-root.nix` | 認証局ルート証明書 |
| `sops.nix` | SOPS (シークレット管理) |
| `users.nix` | ユーザー管理 |
| `kernel.nix` | カーネル設定 |
| `locale.nix` | ローケール設定 |
| `networking.nix` | ネットワーク設定 |
| `nixbuild.nix` | Nix Build |
| `docker.nix` | Docker (オプション) |
| `experimental.nix` | 実験的オプション |
| `unfree.nix` | 非フリーパッケージ許可 |
| `system-packages.nix` | システムパッケージ |
| `bootloader.nix` | ブートローダー設定 |
| `openssh.nix` | OpenSSH (オプション) |
| `clamav.nix` | ClamAV (オプション) |
| `printer.nix` | プリンター (オプション) |
| `root_ca.crt` | ルート証明書ファイル |

### desktop/ — デスクトップ環境

デスクトップホストでのみインポート。

| ファイル | 説明 |
|----------|------|
| `default.nix` | デスクトップ環境モジュールの集約 |
| `displayManager.nix` | SDDM + KDE Plasma 6 |
| `input.nix` | fcitx5, ydotool |
| `sound.nix` | PipeWire |
| `steam.nix` | Steam |

### home/ — Home Manager 共有モジュール

| ファイル | 説明 |
|----------|------|
| `default.nix` | 共通homeモジュール (git, zsh, tmux, nixvim, ...) |
| `git.nix` | Git設定 |
| `gpg.nix` | GPG設定 |
| `eza.nix` | eza (ls置換) |
| `fzf.nix` | fzf |
| `kxkbrc` | KDE キーボードレイアウト |
| `kwinrc` | KDE KWin設定 |

#### desktop/ — デスクトップ用homeモジュール

| ファイル | 説明 |
|----------|------|
| `default.nix` | デスクトップ用homeモジュールの集約 |
| `firefox.nix` | Firefox |
| `kitty.nix` | Kittyターミナル |
| `thunderbird.nix` | Thunderbird |
| `vscode.nix` | VS Code |
| `plasma.nix` | KDE Plasma設定 |
| `xremap.nix` | キーリマップ |
| `libskk/` | libskk設定 |
| `fcitx5/` | Fcitx5 SKK設定 |

#### nixvim/ — Neovim設定

| ファイル | 説明 |
|----------|------|
| `default.nix` | Nixvim宣言的設定 |
| `pre.lua` | 初期化前スクリプト |
| `init.lua` | Neovim初期化スクリプト |

#### starship/ — Starshipプロンプト

| ファイル | 説明 |
|----------|------|
| `default.nix` | Starship設定 |
| `starship.toml` | Starship設定ファイル |

#### tmux/ — tmux設定

| ファイル | 説明 |
|----------|------|
| `default.nix` | tmux設定 |
| `tmux.conf` | tmux設定ファイル |
| `notify.sh` | 通知スクリプト |

#### zsh/ — Zsh設定

| ファイル | 説明 |
|----------|------|
| `default.nix` | Zsh設定 |
| `zshDefault.zsh` | デフォルト設定 |
| `zshMkBefore.zsh` | 初期化前フック |
