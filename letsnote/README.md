# letsnote

ノートPC（Intel CPU、KDE Plasma 6）の設定。

- `config.nix` — ホスト固有のメイン設定 (`component/desktop`, `component/openssh.nix`, `component/clamav.nix` 等をimport)
- `home.nix` — Home Manager設定
- `hardware-configuration.nix` / `extra-hardware-configuration.nix` — ハードウェアスキャン結果
- `tpm.nix` — TPM2 (pkcs11, abrmd)
