{pkgs, ...}:
{
  enable = true;
  defaultEditor = true;
  viAlias = true;
  vimAlias = true;
  vimdiffAlias = true;
  extraLuaConfig = "";
  extraPackages = with pkgs; [
    lua-language-server
    vim-language-server
    bash-language-server
    yaml-language-server
    nil
  ];
  plugins = with pkgs.vimPlugins; [lazy-nvim];
}
