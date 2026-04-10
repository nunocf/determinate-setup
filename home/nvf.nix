{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.generators) mkLuaInline;
  # Editor tool policy:
  # - Prefer executables inherited from the shell/flake dev environment.
  # - Fall back to Nix-provided package paths only when the shell does not provide them.
  # - For version-sensitive project tools (for example `cabal-fmt`), do not reference
  #   Nix package attrs here at evaluation time; let the project shell provide them.
  # - Keep this behavior stable to avoid unrelated global config changes breaking project tooling.
  lspPathFirstLua = pkgs.writeText "nvf-lsp-path-first.lua" ''
    local function path_first_cmd(binary, fallback, extra)
      local cmd = vim.fn.exepath(binary)
      if cmd == nil or cmd == "" then
        cmd = fallback
      end

      local argv = { cmd }
      if extra then
        vim.list_extend(argv, extra)
      end
      return argv
    end

    -- Add future server overrides here to keep LSP resolution shell-first.
    local lsp_fallbacks = {
      ["lua-language-server"] = {
        binary = "lua-language-server",
        fallback = "${pkgs.lua-language-server}/bin/lua-language-server",
      },
      ["marksman"] = {
        binary = "marksman",
        fallback = "${pkgs.marksman}/bin/marksman",
        extra = { "server" },
      },
      ["nil"] = {
        binary = "nil",
        fallback = "${pkgs.nil}/bin/nil",
      },
    }

    do
      local config = vim.lsp.config
      for server_name, spec in pairs(lsp_fallbacks) do
        if config[server_name] then
          config[server_name].cmd = path_first_cmd(spec.binary, spec.fallback, spec.extra)
        end
      end
    end

    do
      if vim.g.haskell_tools and vim.g.haskell_tools.hls then
        vim.g.haskell_tools.hls.cmd = path_first_cmd(
          "haskell-language-server-wrapper",
          "${pkgs.haskell-language-server}/bin/haskell-language-server-wrapper",
          { "--lsp" }
        )
      end
    end

    do
      vim.g.haskell_tools = vim.g.haskell_tools or {}
      vim.g.haskell_tools.hls = vim.g.haskell_tools.hls or {}
      vim.g.haskell_tools.hls.enable = false
      vim.g.haskell_tools.hls.filetypes = { "haskell", "lhaskell" }
    end
  '';
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
        ./nvim/config/core.lua
        ./nvim/config/session.lua
        ./nvim/config/filetypes.lua
        ./nvim/config/diagnostics.lua
        lspPathFirstLua
      ];

      highlight = {
        SnacksNotifierBorderError = {link = "DiagnosticSignError";};
        SnacksNotifierTitleError = {link = "DiagnosticSignError";};
        SnacksNotifierFooterError = {link = "DiagnosticSignError";};
        SnacksNotifierBorderWarn = {link = "DiagnosticSignWarn";};
        SnacksNotifierTitleWarn = {link = "DiagnosticSignWarn";};
        SnacksNotifierFooterWarn = {link = "DiagnosticSignWarn";};
        SnacksNotifierBorderInfo = {link = "DiagnosticSignInfo";};
        SnacksNotifierTitleInfo = {link = "DiagnosticSignInfo";};
        SnacksNotifierFooterInfo = {link = "DiagnosticSignInfo";};
        SnacksNotifierBorderHint = {link = "DiagnosticSignHint";};
        SnacksNotifierTitleHint = {link = "DiagnosticSignHint";};
        SnacksNotifierFooterHint = {link = "DiagnosticSignHint";};
        SnacksPickerDir = {link = "Directory";};
        SnacksPickerPath = {link = "Directory";};
        SnacksPickerDim = {link = "Directory";};
        Visual = {bg = "#374145";};
        Search = {
          fg = "#272e33";
          bg = "#dbbc7f";
        };
        IncSearch = {
          fg = "#272e33";
          bg = "#e69875";
          bold = true;
        };
        CurSearch = {
          fg = "#272e33";
          bg = "#e69875";
          bold = true;
        };
        CursorLine = {bg = "#2f383e";};
        CursorLineNr = {
          fg = "#d3c6aa";
          bold = true;
        };
        PmenuSel = {
          fg = "#d3c6aa";
          bg = "#374145";
          bold = true;
        };
        FloatBorder = {
          fg = "#7a8478";
          bg = "NONE";
        };
        NormalFloat = {bg = "NONE";};
        DiagnosticVirtualTextError = {link = "ErrorMsg";};
        HaskellHole = {link = "DiagnosticError";};
        RainbowDelimiterRed = {fg = "#d699b6";};
        RainbowDelimiterYellow = {fg = "#dbbc7f";};
        RainbowDelimiterBlue = {fg = "#7fbbb3";};
        RainbowDelimiterOrange = {fg = "#e69875";};
        RainbowDelimiterGreen = {fg = "#a7c080";};
        RainbowDelimiterViolet = {fg = "#7a8478";};
        RainbowDelimiterCyan = {fg = "#83c092";};
      };

      options = import ./nvim/options.nix;

      globals = {
        mapleader = ",";
        html_indent_autotags = "html,body,head";
        html_indent_script1 = "inc";
        html_indent_style1 = "inc";
        disable_autoformat = false;
        diagnostic_hover_enabled = false;
      };

      keymaps = import ./nvim/keymaps.nix;
      autocmds = [
        {
          event = ["FileType"];
          pattern = ["markdown"];
          callback = mkLuaInline ''
            function()
              vim.opt_local.wrap = true
              vim.opt_local.spell = true
              vim.opt_local.linebreak = true
              vim.opt_local.textwidth = 100
            end
          '';
        }
        {
          event = ["FileType"];
          pattern = ["gitcommit"];
          callback = mkLuaInline ''
            function()
              vim.opt_local.spell = true
              vim.opt_local.wrap = true
              vim.opt_local.textwidth = 72
            end
          '';
        }
        {
          event = ["FileType"];
          pattern = ["typescript" "typescriptreact" "javascript" "javascriptreact" "tsx"];
          callback = mkLuaInline ''
            function()
              vim.opt_local.shiftwidth = 2
              vim.opt_local.tabstop = 2
              vim.opt_local.expandtab = true
              vim.lsp.inlay_hint.enable(true, { bufnr = 0 })
            end
          '';
        }
        {
          event = ["FileType"];
          pattern = ["ruby"];
          callback = mkLuaInline ''
            function()
              vim.opt_local.shiftwidth = 2
              vim.opt_local.tabstop = 2
              vim.opt_local.expandtab = true
              vim.opt_local.iskeyword:append("?")
              vim.opt_local.iskeyword:append("!")
            end
          '';
        }
      ];
      viAlias = true;
      vimAlias = true;

      diagnostics = {
        config = {
          severity_sort = true;
          signs = true;
          underline = true;
          update_in_insert = false;
          virtual_text = false;
          float = {
            border = "rounded";
            source = "if_many";
            focusable = false;
            style = "minimal";
            wrap = true;
            max_width = 100;
          };
        };
        nvim-lint = import ./nvim/lint.nix {inherit pkgs lib;};
      };

      lsp = import ./nvim/lsp.nix;
      languages = import ./nvim/languages.nix;

      treesitter = {
        enable = true;
        fold = false;
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

      autopairs.nvim-autopairs = {
        enable = true;
        setupOpts = {
          check_ts = true;
          enable_check_bracket_line = false;
          disable_filetype = ["TelescopePrompt" "spectre_panel" "snacks_picker_input"];
          fast_wrap = {};
          map_cr = true;
        };
      };

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
        rainbow-delimiters = {
          enable = true;
          setupOpts = {
            highlight = [
              "RainbowDelimiterRed"
              "RainbowDelimiterYellow"
              "RainbowDelimiterBlue"
              "RainbowDelimiterOrange"
              "RainbowDelimiterGreen"
              "RainbowDelimiterViolet"
              "RainbowDelimiterCyan"
            ];
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
            numbers = "none";
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
        register = {
          "<leader>a" = "Apps/Agents";
          "<leader>f" = "Files";
          "<leader>g" = "Git/Build";
          "<leader>x" = "Diagnostics/Lists";
          "<leader>l" = "LSP";
          "<leader>c" = "Code/Change";
          "<leader>b" = "Buffers";
          "<leader>w" = "Windows";
          "<leader>s" = "Surface/UI";
          "<leader>u" = "Utilities/Toggles";
          "<leader>q" = "Quit/Session/Home";
          "<leader>t" = "Terminal";
          "<leader>m" = "Markdown";
          "<leader>n" = "Nix";
        };
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
