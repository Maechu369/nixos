{
  pkgs,
  lib,
  home-manager,
  nixvim,
  username,
}:
let
  # nixvim設定をhome-managerモジュール単体でevalする(実機hostnameに依存しない)
  hmConfig =
    (home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        nixvim.homeModules.nixvim
        ./default.nix
        ../../../mypc/nixvim.nix
        {
          home.username = username;
          home.homeDirectory = "/home/${username}";
          home.stateVersion = "24.11";
        }
      ];
      extraSpecialArgs = { inherit username; };
    }).config;

  nv = hmConfig.programs.nixvim;

  inherit (builtins)
    attrNames
    attrValues
    elem
    filter
    getAttr
    map
    ;
  drvName = pkg: pkg.pname or (builtins.parseDrvName pkg.name).name;
  inherit (lib)
    filterAttrs
    flatten
    mapAttrs'
    nameValuePair
    pipe
    ;

  # fetchurlベース(LuaRocks由来)のプラグインはsrc.urlからGitHub座標を取り出す
  githubFromUrl =
    url: builtins.match "https://github\\.com/([^/]+)/([^/]+)/archive/(.+)\\.(zip|tar\\.gz)" url;

  pluginSpec =
    name: pkg:
    let
      m = githubFromUrl (pkg.src.url or "");
      fromUrl =
        if m == null then
          { }
        else
          {
            owner = builtins.elemAt m 0;
            repo = builtins.elemAt m 1;
            rev = builtins.elemAt m 2;
          };
    in
    {
      inherit name;
      pname = pkg.pname or (builtins.parseDrvName pkg.name).name;
      version = pkg.version or (builtins.parseDrvName pkg.name).version;
      owner = pkg.src.owner or fromUrl.owner or null;
      repo = pkg.src.repo or fromUrl.repo or null;
      rev = pkg.src.rev or pkg.src.tag or fromUrl.rev or null;
    };

  # 撤廃済みプラグインモジュールはアクセス時点でエラーになるため名前で除外する
  removedPlugins = [
    "cmp-tabnine"
    "editorconfig"
    "nvim-osc52"
    "packer"
    "rust-tools"
    "treesitter-playground"
  ];

  # plugins.<name> は submodule で package(既定 pkgs.vimPlugins.<name>)を持つ
  enabledPluginNames = filter (
    n:
    let
      v = getAttr n nv.plugins;
    in
    (v.enable or false) && (v.package or null) != null
  ) (filter (n: !elem n removedPlugins) (attrNames nv.plugins));

  pluginSpecs = map (n: pluginSpec n (getAttr n nv.plugins).package) enabledPluginNames;

  # nixvimはextraPluginsを { plugin, optional, config } レコードにも包む
  extraPluginDrv = p: if p ? plugin && p ? config then p.plugin else p;
  extraSpecs = map (p: pluginSpec (drvName (extraPluginDrv p)) (extraPluginDrv p)) nv.extraPlugins;
  lspServers = pipe nv.lsp.servers [
    (filterAttrs (n: v: n != "*" && (v.enable or true)))
    (mapAttrs' (
      n: v:
      nameValuePair n {
        name = n;
        package = v.package.pname or n;
        cmd = v.config.cmd or [ ];
      }
    ))
    attrValues
  ];

  luaPackages = map (pkg: {
    pname = pkg.pname;
    version = pkg.version or null;
    owner = pkg.src.owner or null;
    repo = pkg.src.repo or null;
  }) (flatten (map (n: (getAttr n nv.plugins).luaPackages or [ ]) enabledPluginNames));

  data = pkgs.writeText "nixvim-export.json" (
    builtins.toJSON {
      plugins = pluginSpecs;
      extraPlugins = extraSpecs;
      lspServers = lspServers;
      luaPackages = luaPackages;
      initLua = "${hmConfig.home.file."${hmConfig.xdg.configHome}/nvim/init.lua".source}";
    }
  );
in
{
  nixvim-export =
    pkgs.runCommand "nixvim-export"
      {
        nativeBuildInputs = [ pkgs.python3 ];
      }
      ''
        mkdir -p "$out/lua"
        python3 ${./export.py} ${data} "$out"
      '';
}
