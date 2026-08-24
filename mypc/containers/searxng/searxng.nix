{ lib, config, ... }:
{
  services.searx = {
    enable = true;
    settings = {
      server = {
        port = 8080;
        bind_address = "0.0.0.0";
        limiter = false;
        # FIXME 本当は良くないが、ローカル経由でのみ接続できるようNginXを設定
        # もし修正するのであれば、searvices.searx.environmentFileにymlファイルを丸ごと暗号化して入れる
        # 修正する際は、キーを再生成すること
        secret_key = "<nG);+2hk{BBl=_q`NG-LNsO'";
      };
      search = {
        formats = [
          "html"
          "json"
        ];
        default_lang = "ja-JP";
      };
    };
    openFirewall = true;
  };
  networking = {
    firewall = {
      enable = true;
    };
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];
    useHostResolvConf = lib.mkForce false;
  };
  system.stateVersion = "26.11";
}
