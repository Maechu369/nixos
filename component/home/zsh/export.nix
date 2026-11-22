{
  pkgs,
  home-manager,
  username,
}:
let
  homeDir = "/home/${username}";

  # zsh設定をhome-managerモジュール単体でevalする(実機hostnameに依存しない)
  hmConfig =
    (home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        ./default.nix
        {
          home.username = username;
          home.homeDirectory = homeDir;
          home.stateVersion = "25.05";
        }
      ];
    }).config;

  zshFiles = hmConfig.home.file;

  # 1: .zshrc 2: .zshenv 3: .zprofile 4: ~/.zshenv 5: homeDirectory
  data = pkgs.writeText "zsh-export.paths" ''
    ${zshFiles.".config/zsh/.zshrc".source}
    ${zshFiles.".config/zsh/.zshenv".source}
    ${zshFiles.".config/zsh/.zprofile".source}
    ${zshFiles.".zshenv".source}
    ${homeDir}
  '';

  mkExport =
    target:
    pkgs.runCommand "zsh-export-${target}"
      {
        nativeBuildInputs = [ pkgs.python3 ];
      }
      ''
        python3 ${./export.py} ${data} "$out" ${target}
      '';
in
{
  # 出力はtargetごとにREADMEとプラグインパスが異なる
  zsh-export = mkExport "linux";
  zsh-export-termux = mkExport "termux";
}
