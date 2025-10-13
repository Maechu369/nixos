username:
{ pkgs, ... }: {
  xdg.configFile = {
    # "kxkbrc".text = builtins.readFile ./kxkbrc;
    # "kwinrc".text = builtins.readFile ./kwinrc;
    "fcitx5" = {
      source = ./fcitx5;
      recursive = true;
    };
    "libskk/rules" = {
      source = ./libskk;
      recursive = true;
    };
  };
  home = {
    packages = with pkgs; [
      libreoffice-fresh
      libnotify
      obsidian
      slack
      discord
      gparted
      graphviz
      prismlauncher
      filezilla
    ];
  };
  programs = {
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
    thunderbird = {
      enable = true;
      profiles = { };
    };
    vscode = { enable = true; };
  };
  services.xremap = {
    withKDE = true;
    config = {
      virtual_modifiers =
        [ "KEY_KATAKANAHIRAGANA" "KEY_HENKAN" "KEY_MUHENKAN" "F13" ];
      modmap = [
        {
          name = "LCTRL to F13";
          remap = { LEFTCTRL = "F13"; };
        }
        {
          name = "CL to Ctrl";
          remap = { CAPSLOCK = "LEFTCTRL"; };
        }
        {
          name = "無変換 to Esc";
          remap = {
            KEY_MUHENKAN = {
              held = "KEY_MUHENKAN";
              alone = "KEY_ESC";
            };
          };
        }
      ];
      keymap = [
        {
          name = "<C-h> to <BS>";
          remap = { Ctrl_L-h = "Backspace"; };
        }
        {
          name = "<C-m> to <CR>";
          remap = { Ctrl_L-m = "KEY_ENTER"; };
        }
        {
          name = "無変換+J to AltTab";
          remap = { KEY_MUHENKAN-j = "ALT-TAB"; };
        }
        {
          name = "無変換+G to Ctrl+Tab";
          remap = {
            KEY_MUHENKAN-g = "C-TAB";
            KEY_MUHENKAN-t = "C-SHIFT-TAB";
          };
        }
        {
          name = "Open terminal";
          remap = { Win-t = { launch = [ "alacritty" ]; }; };
        }
        {
          name = "Mouse";
          remap = {
            KEY_MUHENKAN-e = { launch = [ "ydotool" "click" "0xC0" ]; };
            KEY_MUHENKAN-r = {
              launch = [ "ydotool" "mousemove" "-w" "-x" "0" "-y" "+2" ];
            };
            KEY_MUHENKAN-f = {
              launch = [ "ydotool" "mousemove" "-w" "-x" "0" "-y" "-2" ];
            };
            KEY_MUHENKAN-w = {
              launch = [ "ydotool" "mousemove" "-x" "0" "-y" "-40" ];
            };
            KEY_MUHENKAN-s = {
              launch = [ "ydotool" "mousemove" "-x" "0" "-y" "+40" ];
            };
            KEY_MUHENKAN-a = {
              launch = [ "ydotool" "mousemove" "-x" "-40" "-y" "0" ];
            };
            KEY_MUHENKAN-d = {
              launch = [ "ydotool" "mousemove" "-x" "+40" "-y" "0" ];
            };
            Shift-KEY_MUHENKAN-w = {
              launch = [ "ydotool" "mousemove" "-x" "0" "-y" "-100" ];
            };
            Shift-KEY_MUHENKAN-s = {
              launch = [ "ydotool" "mousemove" "-x" "0" "-y" "+100" ];
            };
            Shift-KEY_MUHENKAN-a = {
              launch = [ "ydotool" "mousemove" "-x" "-100" "-y" "0" ];
            };
            Shift-KEY_MUHENKAN-d = {
              launch = [ "ydotool" "mousemove" "-x" "+100" "-y" "0" ];
            };
          };
        }
        {
          name = "F13 to Fn";
          remap = {
            F13-j = "End";
            F13-7 = "Home";
            F13-l = "PageDown";
            F13-9 = "PageUp";
            F13-8 = "Up";
            F13-k = "Down";
            F13-u = "Left";
            F13-o = "Right";
          };
        }
      ];
      keypress_delay_ms = 1;
    };
  };
}

