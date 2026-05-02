{ pkgs, ... }:
{
  programs.kitty = {
    enable = true;
    shellIntegration.mode = "no-cursor";
    extraConfig = ''
      cursor_shape block
      scrollbar never
      remember_window_size no
      initial_window_width 800
      initial_window_height 600
      kitty_mod ctrl+shift
      map kitty_mod+c copy_to_clipboard
      map kitty_mod+v paste_from_clipboard
    '';
  };
}
