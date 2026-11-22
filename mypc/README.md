# mypc

メイン環境（デスクトップPC）の設定。AMD CPU + NVIDIA GPU、ZFS、KDE Plasma 6。

- `config.nix` — ホスト固有のメイン設定. `component/` と以下のモジュールをimportsで組み合わせる
- `hardware-configuration.nix` / `extra-hardware-configuration.nix` — ハードウェア設定 (ZFSは `extra-hardware-configuration.nix` 側)
- `home.nix` — Home Manager設定
- `llama.nix` — llama-cpp-cuda サーバー (`llama.home.arpa`:8081) と nginx virtualHost
- `containers/` — NixOSコンテナ gitea / searxng / files (`containers.<name>` + privateNetwork) と nginx virtualHost (ACME)・NAT 設定. `containers/openclaw.nix` は openclaw MicroVM (`192.168.65.2`) へのリバースプロキシで、コンテナではない
- `omp.nix` — omp (oh-my-pi) 設定. llama-swap をプロバイダとして接続
- `nixvim.nix` — ホスト固有のNixvim設定
- `opencode/` — OpenCode設定
- `backup.nix` — borgbackup (毎日, リポジトリ `/mnt/backup/borg-home`)
- `build.nix` — `nix.settings.build-dir = "/build"`
- `audit.nix` — auditd のルール
