args@{ pkgs, plasma-manager, ... }: {
  plasma = {
    enable = true;
    overrideConfig = true;
    input = {
      keyboard = {
        layouts = [{ layout = "jp"; }];
        model = "jp106";
      };
    };
    configFile = {
      kxkbrc = { Layout.LayoutList.immutable = true; };
      kwinrc = {
        Wayland.InputMethod.value =
          "/run/current-system/sw/share/applications/org.fcitx.Fcitx5.desktop";
        Wayland.InputMethod.shellExpand = true;
        Wayland.InputMethod.immutable = true;
      };
    };
  };
  alacritty = {
    enable = true;
    settings = {
      font.size = 11.0;
      colors = {
        normal = {
          black = "#000000";
          red = "#cd0000";
          green = "#00cd00";
          yellow = "#cdcd00";
          blue = "#0000ee";
          magenta = "#cd00cd";
          cyan = "#00cdcd";
          white = "#e5e5e5";
        };
        bright = {
          black = "#7f7f7f";
          red = "#ff0000";
          green = "#00ff00";
          yellow = "#ffff00";
          blue = "#5c5cff";
          magenta = "#ff00ff";
          cyan = "#00ffff";
          white = "#ffffff";
        };
      };
      cursor.style = {
        shape = "Block";
        blinking = "On";
      };
      env = { TERM = "xterm-256color"; };
      keyboard.bindings = [
        {
          key = "C";
          mods = "Control|Shift";
          mode = "~Vi";
          action = "Copy";
        }
        {
          key = "V";
          mods = "Control|Shift";
          mode = "~Vi";
          action = "Paste";
        }
        {
          key = "-";
          mods = "Control";
          chars = "-";
        }
      ];
    };
  };
  firefox = {
    enable = true;
    languagePacks = [ "ja" ];
    policies = {
      DefaultDownloadDirectory = "/home/hiroki/Downloads";
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
  thunderbird = {
    enable = true;
    profiles = { };
  };
}
