{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.generators) mkLuaInline;
in {
  home.file.".config/nvim/after/queries/haskell/injections.scm".source = ./nvim/queries/haskell/injections.scm;
  home.file.".config/lazygit/config.yml".text = ''
    gui:
      border: rounded
      theme:
        selectedLineBgColor:
          - '#374145'
        selectedRangeBgColor:
          - '#374145'
        inactiveBorderColor:
          - '#7a8478'
        activeBorderColor:
          - '#a7c080'
        optionsTextColor:
          - '#dbbc7f'
        cherryPickedCommitBgColor:
          - '#2f383e'
        cherryPickedCommitFgColor:
          - '#a7c080'
        markedBaseCommitBgColor:
          - '#2f383e'
        markedBaseCommitFgColor:
          - '#dbbc7f'
        unstagedChangesColor:
          - '#e67e80'
        defaultFgColor:
          - '#d3c6aa'
        searchingActiveBorderColor:
          - '#e69875'

      authorColors:
        '*': '#d3c6aa'

      branchColorPatterns:
        '.*': '#dbbc7f'
  '';
  home.file."Library/Application Support/lazygit/config.yml".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/lazygit/config.yml";

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
      diagnostics.nvim-lint = import ./nvim/lint.nix {inherit pkgs lib;};

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
          sql
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

      formatter.conform-nvim = import ./nvim/formatters.nix {inherit pkgs lib;};

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
          lsp = {
            progress.enabled = true;
            signature.enabled = true;
            hover.enabled = true;
          };
          presets = {
            bottom_search = true;
            command_palette = true;
            long_message_to_split = true;
            inc_rename = false;
            lsp_doc_border = true;
          };
          notify.enabled = true;
        };
      };

      tabline.nvimBufferline = {
        enable = true;
        setupOpts = {
          options = {
            mode = "buffers";
            themable = true;
            separator_style = "thin";
            diagnostics = "nvim_lsp";
            always_show_bufferline = true;
            enforce_regular_tabs = false;
            hover.enabled = true;
            indicator = {
              style = "icon";
              icon = "▎";
            };
            numbers = "ordinal";
            show_buffer_close_icons = true;
            show_close_icon = false;
            color_icons = true;
            close_command = "bdelete! %d";
            right_mouse_command = "bdelete! %d";
            left_mouse_command = "buffer %d";
            middle_mouse_command = "bdelete! %d";
            buffer_close_icon = "󰅖";
            modified_icon = "●";
            close_icon = "";
            left_trunc_marker = "";
            right_trunc_marker = "";
            tab_size = 22;
            max_name_length = 20;
            truncate_names = true;
            diagnostics_indicator = mkLuaInline ''
              function(count, level)
                local icon = level:match("error") and " " or " "
                return " " .. icon .. count
              end
            '';
            offsets = [
              {
                filetype = "oil";
                text = "Files";
                highlight = "Directory";
                text_align = "left";
              }
            ];
          };
          highlights = {
            fill = {
              bg = "#232a2e";
            };
            background = {
              fg = "#7a8478";
              bg = "#272e33";
            };
            buffer_selected = {
              fg = "#d3c6aa";
              bg = "#3a464c";
              bold = true;
              italic = false;
            };
            buffer_visible = {
              fg = "#9da9a0";
              bg = "#2e383c";
            };
            separator = {
              fg = "#232a2e";
              bg = "#272e33";
            };
            separator_visible = {
              fg = "#232a2e";
              bg = "#2e383c";
            };
            separator_selected = {
              fg = "#232a2e";
              bg = "#3a464c";
            };
            indicator_selected = {
              fg = "#a7c080";
              bg = "#3a464c";
            };
            modified = {
              fg = "#dbbc7f";
              bg = "#272e33";
            };
            modified_visible = {
              fg = "#dbbc7f";
              bg = "#2e383c";
            };
            modified_selected = {
              fg = "#dbbc7f";
              bg = "#3a464c";
            };
            duplicate_selected = {
              fg = "#7fbbb3";
              bg = "#3a464c";
              italic = true;
            };
            duplicate_visible = {
              fg = "#7fbbb3";
              bg = "#2e383c";
              italic = true;
            };
            diagnostic_selected = {
              bg = "#3a464c";
            };
            diagnostic_visible = {
              bg = "#2e383c";
            };
            hint_selected = {
              fg = "#83c092";
              bg = "#3a464c";
            };
            hint_visible = {
              fg = "#83c092";
              bg = "#2e383c";
            };
            info_selected = {
              fg = "#7fbbb3";
              bg = "#3a464c";
            };
            info_visible = {
              fg = "#7fbbb3";
              bg = "#2e383c";
            };
            warning_selected = {
              fg = "#dbbc7f";
              bg = "#3a464c";
            };
            warning_visible = {
              fg = "#dbbc7f";
              bg = "#2e383c";
            };
            error_selected = {
              fg = "#e67e80";
              bg = "#3a464c";
            };
            error_visible = {
              fg = "#e67e80";
              bg = "#2e383c";
            };
            close_button = {
              fg = "#7a8478";
              bg = "#272e33";
            };
            close_button_visible = {
              fg = "#9da9a0";
              bg = "#2e383c";
            };
            close_button_selected = {
              fg = "#d699b6";
              bg = "#3a464c";
            };
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
