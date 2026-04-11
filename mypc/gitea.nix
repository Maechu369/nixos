{ ... }:
{
  services.gitea = {
    enable = true;
    database = {
      type = "sqlite3";
    };
    settings = {
      server = {
        HTTP_ADDR = "127.0.0.1";
        HTTP_PORT = 3000;
        DOMAIN = "gitea.home.arpa";
        ROOT_URL = "http://gitea.home.arpa";
      };
    };
    lfs.enable = true;
    user = "gitea";
    group = "gitea";
  };
}
