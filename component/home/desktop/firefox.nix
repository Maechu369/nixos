{ pkgs, username, ... }: {
  programs.firefox = {
    enable = true;
    languagePacks = [ "ja" ];
    policies = {
      DefaultDownloadDirectory = "/home/${username}/Downloads";
      DisableAppUpdate = true;
      ExtensionSettings = {
        "*" = {
          installation_mode = "normal_installed";
          allowed_types = "extension";
          private_browsing = false;
        };
        "uBlock0@raymondhill.net" = {
          install_url =
            "https://addons.mozilla.org/firefox/downloads/latest/uBlock0@raymondhill.net/latest.xpi";
          private_browsing = true;
        };
        "simple-translate@sienori" = {
          install_url =
            "https://addons.mozilla.org/firefox/downloads/latest/simple-translate@sienori/latest.xpi";
          private_browsing = true;
        };
        "tridactyl.vim@cmcaine.co.uk" = {
          install_url =
            "https://addons.mozilla.org/firefox/downloads/latest/tridactyl.vim@cmcaine.co.uk/latest.xpi";
          private_browsing = true;
        };
      };
    };
  };
}
