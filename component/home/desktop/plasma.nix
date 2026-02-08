{ pkgs, ... }: {
  programs.plasma = {

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
  }

  ;
}
