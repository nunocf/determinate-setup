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
        ./nvim/extraConfig.lua
        ./nvim/whichkey.lua
        ./nvim/trouble.lua
      ];

      options = import ./nvim/options.nix;

      globals.mapleader = ",";

      keymaps = import ./nvim/keymaps.nix;
      viAlias = true;
      vimAlias = true;

      lsp = import ./nvim/lsp.nix;
      languages = import ./nvim/languages.nix;
      diagnostics.nvim-lint = import ./nvim/lint.nix { inherit pkgs lib; };

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

          elixir
          heex
          eex
          erlang

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
      ui.noice = {
        enable = true;
        setupOpts = {
          notify.enabled = false;
          lsp = {
            signature.enabled = true;
            override = {
              "vim.lsp.util.convert_input_to_markdown_lines" = true;
              "vim.lsp.util.stylize_markdown" = true;
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
      tabline.nvimBufferline = import ./nvim/bufferline.nix;
      utility = {
        gitsigns = {
          enable = true;
          setupOpts = {
            current_line_blame = false;
            signcolumn = true;
            numhl = false;
            linehl = false;
          };
        };
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

      mini = import ./nvim/mini.nix;

      notes.todo-comments.enable = true;
    };
  };
}
