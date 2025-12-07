{ config, pkgs, ... }: {
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
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.variables.GTK_IM_MODULE = "fcitx";
  environment.variables.QT_IM_MODULE = "fcitx";

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "jp";
    variant = "";
  };

  environment.variables = {
    XKB_CONFIG_ROOT = "${pkgs.xkeyboard_config}/share/X11/xkb";
  };

  programs.ydotool.enable = true;

  # environment.etc."skel/.config/kxkbrc".text = builtins.readFile ./kxkbrc;
}
