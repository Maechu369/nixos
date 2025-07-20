{pkgs, ...}:
{
  enable = true;
  defaultEditor = true;
  viAlias = true;
  vimAlias = true;
  vimdiffAlias = true;
  extraPackages = with pkgs; [
    lua-language-server
    vim-language-server
    bash-language-server
    yaml-language-server
    nil  # nix lsp
  ];
  plugins = with pkgs.vimPlugins; [lazy-nvim];
  extraLuaConfig = builtins.readFile ./init.lua;
}
