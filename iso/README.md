# NixOS iso image

## 起動したらすること

1. パーティショニング
2. インターネットの確認
  1. `nmcli networking on`
  2. `nmcli radio wifi on`
  3. `nmcli device wifi list`
  4. `nmcli device wifi connect <SSID> --ask` インターネットが通ったらsshもできるように
3. `nixos-install`
4. `nixos-rebuild switch`
