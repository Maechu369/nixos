{ pkgs, config, ... }: {
  i18n = {
    inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        addons = with pkgs; [ fcitx5-mozc fcitx5-skk ];
        waylandFrontend = true;
        settings.inputMethod = {
          Wayland."InputMethod[$e]" =
            "/run/current-system/sw/share/applications/org.fcitx.Fcitx5.desktop";
        };
      };
    };
  };
  services.dbus.packages = [ config.i18n.inputMethod.package ];
  environment.variables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XKB_CONFIG_ROOT = "${pkgs.xkeyboard_config}/share/X11/xkb";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "jp";
    variant = "";
  };

  # Use ydotool by xremap
  programs.ydotool.enable = true;

  # environment.etc."skel/.config/kxkbrc".text = builtins.readFile ./kxkbrc;
}

