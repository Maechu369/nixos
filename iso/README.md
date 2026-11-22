# NixOS iso image

`installation-cd-base.nix` ベースの最小ISO（デスクトップ環境なし）。設定は `iso/configuration.nix`、flake出力は `iso/default.nix`。

## 書き込み

```bash
sudo dd if=nixos--x86_64-linux.iso of=/dev/sda bs=4k status=progress
```

## 起動したらすること

1. パーティショニング
2. インターネットの確認
  1. `nmcli networking on`
  2. `nmcli radio wifi on`
  3. `nmcli device wifi list`
  4. `nmcli device wifi connect <SSID> --ask` インターネットが通ったらsshもできるように
3. `nixos-install`
4. `nixos-rebuild switch`
