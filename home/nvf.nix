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
      };
      extraLuaFiles = [
        ./nvim/theme.lua
        ./nvim/config/core.lua
        ./nvim/config/session.lua
        ./nvim/config/filetypes.lua
        ./nvim/config/diagnostics.lua
      ];

      options = import ./nvim/options.nix;

      globals.mapleader = ",";

      keymaps = import ./nvim/keymaps.nix;
      viAlias = true;
      vimAlias = true;

      lsp = import ./nvim/lsp.nix;
      languages = import ./nvim/languages.nix;
      diagnostics.nvim-lint = import ./nvim/lint.nix { inherit pkgs lib; };

      treesitter = {
        enable = true;
        fold = true;
        textobjects.enable = true;
        # autotagHtml = true;
        autotagHtml = true;
        addDefaultGrammars = false;
        grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          nix
          haskell
          lua
          bash
          ruby

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

      formatter.conform-nvim = import ./nvim/formatters.nix { inherit pkgs lib; };

      autopairs.nvim-autopairs.enable = true;

      autocomplete.blink-cmp = {
        enable = true;
        friendly-snippets.enable = true;

        setupOpts = {
          snippets.preset = "default";

          sources.default = [];

          completion = {
            accept.auto_brackets.enabled = true;
            list.selection.preselect = true;

            documentation = {
              auto_show = true;
              auto_show_delay_ms = 200;
            };
          };

          keymap = {
            preset = "super-tab";
            "<C-y>" = ["select_and_accept"];
          };

          cmdline = {
            enabled = true;
            keymap = {
              preset = "cmdline";
            };
          };
        };
      };
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

      terminal.toggleterm = {
        enable = true;
        setupOpts = {
          direction = "float";
        };
        mappings.open = "<leader>tt";
        lazygit = {
          enable = true;
        };
      };

      binds.whichKey = {
        enable = true;
        setupOpts = {
          preset = "modern";
          icons = {
            breadcrumb = "»";
            separator = "➜";
            group = "+";
          };
          win.border = "rounded";
        };
      };
      statusline.lualine = import ./nvim/lualine.nix;
      utility = {
        motion.flash-nvim = import ./nvim/flash.nix;
        surround.enable = true;
        sleuth.enable = true;
        oil-nvim = {
          enable = true;
          setupOpts = {
            skip_confirm_for_simple_edits = true;
            default_file_explorer = true;
            float = {
              padding = 2;
              max_width = 90;
              max_height = 30;
            };
          };
        };
        snacks-nvim = import ./nvim/snacks-nvim.nix;
        direnv.enable = true;
      };

      git.gitsigns = {
        enable = true;
        setupOpts = {
          current_line_blame = false;
          signcolumn = true;
          numhl = false;
          linehl = false;
        };
      };

      mini = import ./nvim/mini.nix;
    };
  };
}
