{
  enable = true;
  defaultEditor = true;
  viAlias = true;
  vimAlias = true;
  vimdiffAlias = true;
  # extraPackages = with pkgs; [
  #   lua-language-server
  #   vim-language-server
  #   bash-language-server
  #   yaml-language-server
  #   nil  # nix lsp
  # ];

  clipboard = {
    register = "unnamedplus";
    providers.wl-copy.enable = true;
  };

  opts = {
    fileformats = "unix,dos";

    swapfile = false;

    visualbell = true;
    termguicolors = true;
    showmatch = true;
    wildmode = "list:longest";
    cursorline = true;
    display = "lastline";
    list = true;
    listchars = {
      tab = "<->";
      trail = "-";
    };

    number = true;
    relativenumber = true;

    nrformats = "bin,hex,alpha,unsigned";
  };

  autoGroups = {
    init.clear = true;
  };

  nixpkgs.useGlobalPackages = true;
  colorscheme = "torte";
  plugins = {
    treesitter = {
      enable = true;
      settings = {
        # auto_install = true;
        highlight = {
          enable = true;
        };
      indent.enable = true;
      };
    };
    lualine = {
      enable = true;
    };
  };
  lsp = {
    keymaps = [
      {key = "K"; lspBufAction = "hover";}
      {key = "gf"; lspBufAction = "format";}
      {key = "gr"; lspBufAction = "references";}
      {key = "gd"; lspBufAction = "definition";}
      {key = "gD"; lspBufAction = "declaration";}
      {key = "gi"; lspBufAction = "implementation";}
      {key = "gt"; lspBufAction = "type_definition";}
      {key = "gn"; lspBufAction = "rename";}
      {key = "ga"; lspBufAction = "code_action";}
    ];
  };

  # extraConfigLuaPre = builtins.readFile ./pre.lua;
  extraConfigLuaPost = builtins.readFile ./init.lua;
}
# vim: fdm=marker:fdc=2:fdl=1:et:sw=2:ts=2
