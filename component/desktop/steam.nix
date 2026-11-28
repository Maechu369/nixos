{ pkgs, ... }: {
  programs.steam = {
    # 設定は左上のSteamアイコンから開くことができる。
    # 言語設定: インターフェース
    # Proton設定: 互換性 デフォルトでProton Experimental
    enable = true;
    # Remote Play / Source 専用サーバー / LAN 転送は使わないので firewall を開かない。
    # 開くと送信元制限なしで 27015 (SRCDS の RCON) や 27031-27037 を LAN 全体に晒す。
    fontPackages = with pkgs; [ migu ];
  };
}
