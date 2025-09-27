{ pkgs, ... }: {
  programs.steam = {
    # 設定は左上のSteamアイコンから開くことができる。
    # 言語設定: インターフェース
    # Proton設定: 互換性 デフォルトでProton Experimental
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    fontPackages = with pkgs; [ migu ];
  };
}
