{ pkgs, ... }: {
  services.xremap = {
    enable = true;
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
