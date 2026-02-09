{ pkgs, lib, ... }: {
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

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
      aerial = {
        enable = true;
        luaConfig.post = ''
          require("aerial").setup({
            on_attach = function(bufnr)
              vim.keymap.set("n", "{", "<Cmd>AerialPrev<CR>", {buffer = bufnr})
              vim.keymap.set("n", "}", "<Cmd>AerialPrev<CR>", {buffer = bufnr})
            end
          })
          nmap("<leader>a", "<Cmd>AerialToggle!<CR>")
        '';
      };
      web-devicons.enable = true;
      telescope = {
        enable = true;
        keymaps = {
          "<leader>ff" = { action = "find_files"; };
          "<leader>fg" = { action = "live_grep"; };
          "<leader>fb" = { action = "buffers"; };
          "<leader>fh" = { action = "help_tags"; };
          "<leader>sk" = { action = "keymaps"; };
        };
      };
      nvim-autopairs = {
        enable = true;
        settings = {
          check_ts = true;
          disable_in_macro = true;
          map_bs = true;
          map_ch = true;
          ts_config = { nix = [ "string_fragment" ]; };
          fast_wrap = { map = "<C-F>"; };
        };
        luaConfig.post = ''
          local npairs = require("nvim-autopairs")
          local cmp_autopairs = require("nvim-autopairs.completion.cmp")
          local cmp = require("cmp")
          cmp.event:on(
            "confirm_done",
            cmp_autopairs.on_confirm_done()
          )

          local Rule = require("nvim-autopairs.rule")

          npairs.add_rules(
            {
              Rule("$", "$", { "tex", "latex", "markdown" })
            }
          )
        '';
      };
      cmp-nvim-lsp.enable = true;
      cmp-buffer.enable = true;
      cmp-path.enable = true;
      cmp-cmdline.enable = true;
      cmp_luasnip.enable = true;
      cmp = {
        enable = true;
        settings = {
          experimental = { ghost_text = true; };
          snippet.expand = ''
            function(args)
              require("luasnip").lsp_expand(args.body)
            end
          '';
          sources = [
            { name = "nvim_lsp"; }
            { name = "buffer"; }
            {
              name = "path";
            }
            # When enable source 'cmdline', make some erros in code with wrong bracket info by parser bugs.
            # { name = "cmdline"; }
            {
              name = "luasnip";
              option.show_autosnippets = true;
            }
          ];
          mapping = {
            "<C-P>" = "cmp.mapping.select_prev_item()";
            "<C-N>" = "cmp.mapping.select_next_item()";
            "<C-L>" = "cmp.mapping.complete()";
            "<C-E>" = "cmp.mapping.abort()";
            "<CR>" = ''
              cmp.mapping(function(fallback)
                local luasnip = require("luasnip")
                if cmp.visible() then
                  if luasnip.expandable() then
                    luasnip.expand()
                  else
                    cmp.confirm({select=true})
                  end
                else
                  fallback()
                end
              end)'';
            "<Tab>" = ''
              cmp.mapping(function(fallback)
                local luasnip = require("luasnip")
                if cmp.visible() then
                  cmp.select_next_item()
                elseif luasnip.locally_jumpable(1) then
                  luasnip.jump(1)
                else
                  fallback()
                end
              end, {"i", "s"})'';
            "<S-Tab>" = ''
              cmp.mapping(function(fallback)
                local luasnip = require("luasnip")
                if cmp.visible() then
                  cmp.select_next_item()
                elseif luasnip.locally_jumpable(-1) then
                  luasnip.jump(-1)
                else
                  fallback()
                end
              end, {"i", "s"})'';
          };
        };
      };
      luasnip = { enable = true; };
      lualine = { enable = true; };
      gitsigns = {
        enable = true;
        settings = {
          signcolumn = true;
          numhl = true;
        };
      };
      dial = {
        enable = true;
        luaConfig.post = ''
          local dial = require("dial.map")
          nmap("<C-A>", function () dial.manipulate("increment", "normal") end)
          nmap("<C-X>", function () dial.manipulate("decrement", "normal") end)
          nmap("g<C-A>", function () dial.manipulate("increment", "gnormal") end)
          nmap("g<C-X>", function () dial.manipulate("decrement", "gnormal") end)
          map("v", "<C-A>", function () dial.manipulate("increment", "visual") end)
          map("v", "<C-X>", function () dial.manipulate("decrement", "visual") end)
          map("v", "g<C-A>", function () dial.manipulate("increment", "gvisual") end)
          map("v", "g<C-X>", function () dial.manipulate("decrement", "gvisual") end)
          local augend = require("dial.augend")
          require("dial.config").augends:register_group({
            default = {
              augend.constant.new{
                elements = {"True", "False"},
                word = true,
                cycle = true,
              },
              augend.constant.new{
                elements = {"- [ ] ", "- [x] "},
                word = false,
                cycle = true,
              },
              augend.integer.alias.decimal,
              augend.integer.alias.hex,
              augend.date.alias["%Y/%m/%d"],
              augend.constant.alias.bool,
              augend.constant.alias.alpha,
              augend.constant.alias.Alpha,
              augend.hexcolor.new { case = "lower" }
            }
          })
        '';
      };
      repeat.enable = true;
      sandwich.enable = true;
      indent-blankline = {
        enable = true;
        luaConfig.post = ''
          vim.api.nvim_set_hl(0, "IndentBlanklineIndent1", {
            bg = "#400000", nocombine = true
          })
          vim.api.nvim_set_hl(0, "IndentBlanklineIndent2", {
            bg = "#003000", nocombine = true
          })
          local highlight = {"IndentBlanklineIndent1", "IndentBlanklineIndent2"}
          require("ibl").setup({
            indent = {
              highlight = highlight,
              char = ""
            },
            whitespace = {
              highlight = highlight,
              remove_blankline_trail = false
            },
            scope = {enabled = false}
          })
        '';
      };
      highlight-colors.enable = true;
    };
    extraPlugins = with pkgs.vimPlugins; [
      quick-scope
      camelcasemotion
      clever-f-vim
      nvim-hlslens
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
        local _is_support_document_highlight = function()
          return vim.lsp.get_clients()[1].server_capabilities.documentHighlightProvider
        end
        local is_support_document_highlight = function()
          success, result = pcall(_is_support_document_highlight)
          if success then
            return result
          end
          return false
        end
        vim.api.nvim_create_autocmd({"CursorHold", "CursorHoldI"}, {
          group="lsp_document_highlight",
          buffer=0,
          callback=function()
            return (is_support_document_highlight() and vim.lsp.buf.document_highlight())
          end
        })
        vim.api.nvim_create_autocmd({"CursorMoved", "CursorMovedI"}, {
          group="lsp_document_highlight",
          buffer=0,
          callback=function()
            return (is_support_document_highlight() and vim.lsp.buf.clear_references())
          end
        })
      '';
      servers = {
        lua_ls.enable = true;
        nil_ls = {
          enable = true;
          package = pkgs.nil;
          config = {
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
        pyright = {
          enable = true;
          package = pkgs.pyright;
          config = {
            cmd = [ "pyright-langserver" "--stdio" ];
            filetypes = [ "python" ];
            settings = {
              # pyright = { formatting.command = [ "ruff" "format" ]; };
            };
          };
        };
        ruff = {
          enable = true;
          package = pkgs.ruff;
          config = {
            cmd = [ "ruff" "server" ];
            filetypes = [ "python" ];
            settings = {
              ruff = { formatting.command = [ "ruff" "format" ]; };
            };
          };
        };
      };
    };

    extraConfigLuaPre = builtins.readFile ./pre.lua;
    extraConfigLuaPost = builtins.readFile ./init.lua;
  };
}
# vim: fdm=marker:fdc=2:fdl=1:et:sw=2:ts=2
