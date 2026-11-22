# component

複数ホストで共有するモジュール. `mypc` と `letsnote` の `config.nix` が `../component` 経由で導入する.
(`iso` / `minimum` / `openclaw` は component をimportしない)

- `default.nix` — mypc / letsnote が必ず導入: experimental, bootloader, kernel, networking, printer, locale, unfree, sops, system-packages, docker, users, ca-root
- `ip.nix` — ホスト名 → 固定IPの一覧. `flake.nix` の `_module.args.ip` として読み込まれ、mypc / letsnote の `specialArgs` 経由で各モジュールに渡される
- `trusted-users.nix` — `nix.settings.trusted-users` に root とログインユーザーを追加
- `ca-root.nix` / `root_ca.crt` — `root_ca.crt` をシステムの信頼済み証明書に追加
- `openssh.nix`, `clamav.nix` — 任意のホストで個別にimport
- `desktop/` — デスクトップホストでのみimport. SDDM + Plasma 6, fcitx5/ydotool, PipeWire, Steam
- `home/` — home-managerの共有モジュール. `default.nix` が git, gpg, eza, fzf, zsh, tmux, nixvim, starship を集約. `home/desktop/` はデスクトップ用アプリ (firefox, kitty, thunderbird, vscode, plasma, xremap) と fcitx5 / libskk 設定
