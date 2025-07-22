{ pkgs, lib, ... }: {
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
    lspconfig = { enable = true; };
    treesitter = {
      enable = true;
      settings = {
        # auto_install = true;
        highlight = { enable = true; };
        indent.enable = true;
      };
    };
    lualine = { enable = true; };
    sandwich = { enable = true; };
  };
  extraPlugins = with pkgs.vimPlugins; [
    nvim-autopairs
  ];
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
    ];
    luaConfig.post = ''
      vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {virtual_text = false}
      )
      vim.keymap.set("n", "ge", "<Cmd>lua vim.diagnostic.open_float()<CR>")
      vim.keymap.set("n", "g]", "<Cmd>lua vim.diagnostic.goto_next()<CR>")
      vim.keymap.set("n", "g[", "<Cmd>lua vim.diagnostic.goto_prev()<CR>")

      -- Variable highlight
      -- ref: https://zenn.dev/botamotch/scraps/62eda54e7fba90
      vim.opt.updatetime = 500
      local fg = "#a0ff00"
      local bg = "#208080"
      vim.api.nvim_set_hl(0, "LspReferenceText",
        {cterm = {underline = true}, ctermfg = 1, ctermbg = 8, underline = true, fg=fg, bg=bg})
      vim.api.nvim_set_hl(0, "LspReferenceRead",
        {cterm = {underline = true}, ctermfg = 1, ctermbg = 8, underline = true, fg=fg, bg=bg})
      vim.api.nvim_set_hl(0, "LspReferenceWrite",
        {cterm = {underline = true}, ctermfg = 1, ctermbg = 8, underline = true, fg=fg, bg=bg})
      vim.api.nvim_create_augroup("lsp_document_highlight", {})
      vim.api.nvim_create_autocmd({"CursorHold", "CursorHoldI"}, {
        group="lsp_document_highlight",
        callback=vim.lsp.buf.document_highlight
      })
      vim.api.nvim_create_autocmd({"CursorMoved", "CursorMovedI"}, {
        group="lsp_document_highlight",
        callback=vim.lsp.buf.clear_references
      })
    '';
    servers = {
      lua_ls.enable = true;
      nil_ls = {
        enable = true;
        settings = {
          cmd = [ "nil" ];
          filetypes = [ "nix" ];
          settings = {
            nil = {
              formatting.command = [ "nixfmt" ];
              nix.flake = {
                autoArchive = false;
                autoEvalInputs = true;
              };
            };
          };
        };
      };
    };
  };

  # extraConfigLuaPre = builtins.readFile ./pre.lua;
  extraConfigLuaPost = builtins.readFile ./init.lua;
}
# vim: fdm=marker:fdc=2:fdl=1:et:sw=2:ts=2
