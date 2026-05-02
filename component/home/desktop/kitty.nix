{ pkgs, ... }:
{
  programs.kitty = {
    enable = true;
    shellIntegration.mode = "no-cursor";
    settings = {
      text_composition_strategy = "legacy";
      cursor_shape = "block";
      scrollbar = "never";
      remember_window_size = "no";
      initial_window_width = "800";
      initial_window_height = "600";
      kitty_mod = "ctrl+shift";
    };
    keybindings = {
      "kitty_mod+c" = "copy_to_clipboard";
      "kitty_mod+v" = "paste_from_clipboard";
    };
  };
}
