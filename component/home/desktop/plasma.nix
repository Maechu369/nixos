{ pkgs, ... }: {
  programs.plasma = {

    enable = true;
    shortcuts = { };
    configFile = {
      kuriikwsfilterrc.General = {
        EnableWebShortcuts = true;
        KeywordDelimiter = ":";
        PreferredWebShortcuts = "";
        UsePreferredWebShortcutsOnly = false;
      };
      kwinrc.Wayland."InputMethod[$ei]" =
        "/run/current-system/sw/share/applications/org.fcitx.Fcitx5.desktop";
      kxkbrc.Layout = {
        DisplayNames = "";
        "LayoutList[$i]" = "jp";
        Model = "jp106";
        Use = true;
        VariantList = "";
      };
      spectaclerc = {
        ImageSave.translatedScreenshotsFolder = "スクリーンショット";
        VideoSave.translatedScreencastsFolder = "画面録画";
      };
    };
  };
}
