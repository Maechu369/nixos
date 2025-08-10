username: {
  userName = username;
  serviceMode = "system";
  config = {
    virtual_modifiers = [ "KEY_KATAKANAHIRAGANA" "KEY_HENKAN" "KEY_MUHENKAN" ];
    modmap = [
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
    ];
    keypress_delay_ms = 1;
  };
}
