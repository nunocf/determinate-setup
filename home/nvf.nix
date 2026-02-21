{
  pkgs,
  lib,
  ...
}: {
  programs.nvf = {
    enable = true;
    settings.vim = {
      theme = {
        enable = true;
        name = "everforest";
        style = "hard";
        extraConfig = ''
          local function fix_snacks_links()
                    	local map = {
                    		Error = "DiagnosticSignError",
                    		Warn = "DiagnosticSignWarn",
                    		Info = "DiagnosticSignInfo",
                    		Hint = "DiagnosticSignHint",
                    	}

                    	for lvl, sign in pairs(map) do
                    		vim.api.nvim_set_hl(0, "SnacksNotifierBorder" .. lvl, { link = sign })
                    		vim.api.nvim_set_hl(0, "SnacksNotifierTitle" .. lvl, { link = sign })
                    		vim.api.nvim_set_hl(0, "SnacksNotifierFooter" .. lvl, { link = sign })
                    	end
                    end

                    vim.api.nvim_create_autocmd("ColorScheme", { callback = fix_snacks_links })
                    fix_snacks_links()


        '';
      };
      extraLuaFiles = [
        ./nvim/extraConfig.lua
      ];

      options = {
        tabstop = 2;
        shiftwidth = 2;
        expandtab = true;
        autoindent = true;
        smartindent = true;
        copyindent = true;
        preserveindent = true;
        breakindent = true;
        smarttab = true;
        mouse = "a";
        splitbelow = true;
        splitright = true;
        updatetime = 50;
        ignorecase = true;
        smartcase = true;
        swapfile = false;
        autoread = true;
        backup = false;
        undofile = true;
        signcolumn = "yes";
        scrolloff = 10;
        showmode = false;
        cmdheight = 0;
        backspace = "indent,eol,start";
      };

      globals.mapleader = ",";

      keymaps = import ./nvim/keymaps.nix;
      viAlias = true;
      vimAlias = true;

      lsp = {
        enable = true;
        trouble = {
          enable = true;
          setupOpts = {
            lsp.win.position = "right";
          };
        };
        formatOnSave = false;
      };

      languages = {
        nix.enable = true;
        markdown.enable = true;
        haskell.enable = true;
        lua.enable = true;

        html.enable = true;
        css.enable = true;
        bash.enable = true;

        ts.enable = true;
      };
      diagnostics.nvim-lint = {
        enable = true;
        lint_after_save = true;

        linters_by_ft = {
          # nix
          nix = [
            "statix"
            "deadnix"
          ];

          # haskell
          haskell = ["hlint"];

          # shell
          sh = ["shellcheck"];
          bash = ["shellcheck"];

          # lua (optional but useful)
          lua = ["luacheck"];

          # web / ts
          javascript = ["eslint_d"];
          javascriptreact = ["eslint_d"];
          typescript = ["eslint_d"];
          typescriptreact = ["eslint_d"];

          # css (optional but great if you use stylelint)
          css = ["stylelint"];
          scss = ["stylelint"];

          # markdown (optional)
          markdown = ["markdownlint-cli2"];
        };

        linters = {
          statix.cmd = lib.getExe pkgs.statix;
          deadnix.cmd = lib.getExe pkgs.deadnix;
          hlint.cmd = lib.getExe pkgs.hlint;
          shellcheck.cmd = lib.getExe pkgs.shellcheck;

          # If this attr isn't present in your nixpkgs, use pkgs.luajitPackages.luacheck
          luacheck.cmd = lib.getExe pkgs.luajitPackages.luacheck;

          markdownlint-cli2.cmd = lib.getExe pkgs.nodePackages.markdownlint-cli2;

          eslint_d = {
            cmd = lib.getExe pkgs.nodePackages.eslint_d;

            required_files = [
              "eslint.config.js"
              "eslint.config.mjs"
              "eslint.config.cjs"
              ".eslintrc"
              ".eslintrc.js"
              ".eslintrc.cjs"
              ".eslintrc.json"
              ".eslintrc.yaml"
              ".eslintrc.yml"
            ];
          };

          stylelint = {
            cmd = lib.getExe pkgs.nodePackages.stylelint;
            required_files = [
              "stylelint.config.js"
              "stylelint.config.cjs"
              "stylelint.config.mjs"
              ".stylelintrc"
              ".stylelintrc.js"
              ".stylelintrc.cjs"
              ".stylelintrc.json"
              ".stylelintrc.yaml"
              ".stylelintrc.yml"
            ];
          };
        };
      };

      clipboard = {
        enable = true;
        registers = "unnamedplus";
      };

      treesitter = {
        enable = true;
        fold = true;
        # textobjects.enable = true;
        # autotagHtml = true;
        autotagHtml = true;
        addDefaultGrammars = false;
        grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          nix
          haskell
          lua
          bash

          html
          css
          javascript
          typescript
          tsx
          json

          yaml
          toml
          dockerfile
          gitignore
          regex

          markdown
          markdown_inline
          query
          vim
          vimdoc
          diff
        ];
      };

      formatter.conform-nvim = {
        enable = true;
        setupOpts = {
          format_on_save = {
            timeout_ms = 2000;
            lsp_format = "fallback";
          };

          formatters_by_ft = {
            # nix
            nix = ["alejandra"];

            # haskell
            haskell = ["fourmolu"];

            # lua
            lua = ["stylua"];

            # shell
            sh = ["shfmt"];
            bash = ["shfmt"];

            # web / ts module (includes js/ts/tsx typically)
            javascript = ["prettierd"];
            javascriptreact = ["prettierd"];
            typescript = ["prettierd"];
            typescriptreact = ["prettierd"];
            tsx = ["prettierd"];

            html = ["prettierd"];
            css = ["prettierd"];
            scss = ["prettierd"];

            # docs/config
            json = ["prettierd"];
            jsonc = ["prettierd"];
            yaml = ["prettierd"];
            markdown = ["prettierd"];
          };

          formatters = {
            alejandra.command = lib.getExe pkgs.alejandra;
            fourmolu.command = lib.getExe pkgs.fourmolu;
            stylua.command = lib.getExe pkgs.stylua;
            shfmt.command = lib.getExe pkgs.shfmt;
            prettierd.command = lib.getExe pkgs.prettierd;
          };
        };
      };

      autopairs.nvim-autopairs.enable = true;

      autocomplete.nvim-cmp.enable = true;
      lineNumberMode = "number";

      visuals = {
        nvim-cursorline = {
          enable = true;
          setupOpts = {
            cursorline.enable = true;
          };
        };
        nvim-web-devicons.enable = true;
      };
      ui.noice = {
        enable = true;
        setupOpts = {
          notify.enabled = false;
          lsp = {
            signature.enabled = true;
            override = {
              "vim.lsp.util.convert_input_to_markdown_lines" = true;
              "vim.lsp.util.stylize_markdown" = true;
              "cmp.entry.get_documentation" = true;
            };
          };

          routes = [
            {
              filter = {
                event = "msg_show";
                any = [
                  {find = "%d+L, %d+B";}
                  {find = "; after #%d+";}
                  {find = "; before #%d+";}
                ];
              };
              view = "mini";
            }
          ];

          presets = {
            bottom_search = true;
            command_palette = true;
            long_message_to_split = true;
          };
        };
      };

      terminal.toggleterm = {
        enable = true;
        setupOpts = {
          direction = "float";
        };
        mappings.open = "<leader>t";
        lazygit = {
          enable = true;
        };
      };

      binds.whichKey = {
        enable = true;
        setupOpts = {
          show_help = false;
          operators_ignore = [
            "gc"
            "gz"
            "gZ"
            "i"
            "a"
          ];
        };
      };
      statusline.lualine = import ./nvim/lualine.nix;
      tabline.nvimBufferline = import ./nvim/bufferline.nix;
      utility = {
        motion.flash-nvim = import ./nvim/flash.nix;
        surround.enable = true;
        sleuth.enable = true;
        oil-nvim = {
          enable = true;
          setupOpts = {
            skip_confirm_for_simple_edits = true;
            default_file_explorer = true;
          };
        };
        snacks-nvim = import ./nvim/snacks-nvim.nix;
      };

      mini = import ./nvim/mini.nix;
      startPlugins = [
        pkgs.vimPlugins.vim-nix
      ];
    };
  };
}
