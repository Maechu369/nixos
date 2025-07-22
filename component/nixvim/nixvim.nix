{ lib, ... }: {
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
    shiftwidth = 2;
    tabstop = 2;

    number = true;
    relativenumber = true;

    nrformats = "bin,hex,alpha,unsigned";
  };

  autoGroups = { init.clear = true; };

  autoCmd = [
    {
      event = "FileType";
      pattern = "nix";
      command = "setl sw=2 ts=2 et";
    }
    {
      event = "FileType";
      pattern = "lua";
      command = "setl sw=2 ts=2 et";
    }
  ];

  nixpkgs.useGlobalPackages = true;
  colorscheme = "torte";
  plugins = {
    treesitter = {
      enable = true;
      settings = {
        # auto_install = true;
        highlight = { enable = true; };
        indent.enable = true;
      };
    };
    lualine = { enable = true; };
  };
  lsp = {
    keymaps = [
      {
        key = "K";
        lspBufAction = "hover";
      }
      {
        key = "gf";
        lspBufAction = "format";
      }
      {
        key = "gr";
        lspBufAction = "references";
      }
      {
        key = "gd";
        lspBufAction = "definition";
      }
      {
        key = "gD";
        lspBufAction = "declaration";
      }
      {
        key = "gi";
        lspBufAction = "implementation";
      }
      {
        key = "gt";
        lspBufAction = "type_definition";
      }
      {
        key = "gn";
        lspBufAction = "rename";
      }
      {
        key = "ga";
        lspBufAction = "code_action";
      }
      {
        key = "ge";
        lspBufAction = "";
      }
    ];
    luaConfig.post = ''
      vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {virtual_text = false}
      )
      vim.keymap.set("n", "ge", "<Cmd>lua vim.diagnostic.open_float()<CR>")
      vim.keymap.set("n", "g]", "<Cmd>lua vim.diagnostic.goto_next()<CR>")
      vim.keymap.set("n", "g[", "<Cmd>lua vim.diagnostic.goto_prev()<CR>")
    '';
    servers = {
      lua_ls.enable = true;
      nil_ls = {
        enable = true;
        # settings = {cmd = ["nil"]; filetypes = [ "nix" ]; settings = {"nil".formatting.command="nixfmt";};};
      };
    };
  };

  # extraConfigLuaPre = builtins.readFile ./pre.lua;
  extraConfigLuaPost = builtins.readFile ./init.lua;
}
# vim: fdm=marker:fdc=2:fdl=1:et:sw=2:ts=2
