{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.generators) mkLuaInline;
  inherit (lib.hm.dag) entryAfter;
  isWorkMacbook = config.my.machine.homeConfigurationName == "work-macbook";
  # On the work laptop, bake the exact claude binary path in at eval time so
  # toggle_codex() never falls back to codex (which would hit the OpenAI API
  # and be blocked by Cloudflare Zero Trust).
  aiCmdLua = pkgs.writeText "nvf-ai-cmd.lua" (
    if isWorkMacbook
    then ''
      vim.g.ai_override_cmd = "${pkgs.claude-code}/bin/claude"
    ''
    else ""
  );
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

  '';
  dropbarLua = pkgs.writeText "nvf-dropbar.lua" ''
    local ok, dropbar = pcall(require, "dropbar")
    if not ok then
    	return
    end

    local sources = require("dropbar.sources")

    dropbar.setup({
    	bar = {
    		sources = function(buf, _)
    			if vim.bo[buf].buftype == "terminal" then
    				return { sources.terminal }
    			end

    			return { sources.path }
    		end,
    	},
    })


  '';
in {
  home.file.".config/nvim/queries/haskell/injections.scm".source = ./nvim/queries/haskell/injections.scm;
  home.file.".config/nvim/queries/nix/injections.scm".source = ./nvim/queries/nix/injections.scm;
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
        aiCmdLua
        ./nvim/config/core.lua
        ./nvim/config/session.lua
        ./nvim/config/filetypes.lua
        ./nvim/config/diagnostics.lua
        lspPathFirstLua
        dropbarLua
      ];
      luaConfigRC.render-markdown = ''
        require("render-markdown").setup({
          file_types = { "markdown", "codecompanion" },
        })
      '';
      luaConfigRC.img-clip = ''
        require("img-clip").setup({
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            use_absolute_path = true,
          },
        })
      '';
      luaConfigRC.edgy-nvim = ''
        require("edgy").setup({
          right = {
            {
              title = "CodeCompanion",
              ft = "codecompanion",
              size = { width = 0.40 },
            },
          },
          animate = { enabled = false },
        })
      '';
      luaConfigRC.vectorcode = ''
        require("vectorcode").setup()
      '';
      luaConfigRC.haskell-tools-cleanup = entryAfter ["haskell-tools-nvim"] ''
        local wrapper = vim.fn.exepath("haskell-language-server-wrapper")
        if wrapper ~= "" then
          local ht = vim.g.haskell_tools
          if type(ht) ~= "table" then
            ht = {}
          end
          if type(ht.hls) ~= "table" then
            ht.hls = {}
          end

          ht.hls.root_dir = nil
          ht.hls.enable = nil
          ht.hls.filetypes = nil

          if type(ht.tools) ~= "table" then
            ht.tools = {}
          end
          if type(ht.tools.hover) ~= "table" then
            ht.tools.hover = {}
          end
          ht.tools.hover.enable = nil

          ht.hls.cmd = {
            wrapper,
            "--lsp",
          }

          vim.g.haskell_tools = ht
        end
      '';
      additionalRuntimePaths = ["~/.config/nvim"];
      startPlugins = [
        pkgs.vimPlugins."dropbar-nvim"
        pkgs.vimPlugins.render-markdown-nvim
        pkgs.vimPlugins.img-clip-nvim
        pkgs.vimPlugins.edgy-nvim
        pkgs.vimPlugins.vectorcode-nvim
        pkgs.vimPlugins.codecompanion-history-nvim
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
          fg = "#a7c080";
          bg = "#2d353b";
        };
        NormalFloat = {
          fg = "#d3c6aa";
          bg = "#2d353b";
        };
        DiagnosticFloating = {
          fg = "#d3c6aa";
          bg = "#2d353b";
        };
        DiagnosticFloatingBorder = {
          fg = "#a7c080";
          bg = "#2d353b";
        };
        DiagnosticVirtualTextError = {link = "ErrorMsg";};
        DiagnosticInfo = {fg = "#7fbbb3";};
        HaskellHole = {link = "DiagnosticError";};
        NixInjectedLuaBackground = {bg = "#273036";};
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
          pattern = ["*"];
          callback = mkLuaInline ''
            function()
            	if vim.bo.buftype ~= "" then
            		return
            	end

            	vim.opt_local.spell = false
            end


          '';
        }
        {
          event = ["FileType"];
          pattern = ["bash" "css" "elixir" "haskell" "heex" "html" "javascript" "javascriptreact" "jsonc" "lua" "nix" "ruby" "scss" "sh" "tsx" "typescript" "typescriptreact" "yaml"];
          callback = mkLuaInline ''
            function()
            	if vim.bo.buftype ~= "" then
            		return
            	end

            	vim.opt_local.spell = true
            end


          '';
        }
        {
          event = ["BufReadPost" "BufNewFile"];
          pattern = ["*.md" "*.markdown" "*.mkd"];
          callback = mkLuaInline ''
            function()
            	if vim.bo.buftype ~= "" then
            		return
            	end

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
            	if vim.bo.buftype ~= "" or vim.bo.filetype == "" then
            		return
            	end

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
            border = "single";
            source = "if_many";
            focusable = false;
            header = "";
            wrap = true;
            width = 72;
            max_width = 84;
          };
        };
        nvim-lint = import ./nvim/lint.nix {inherit pkgs lib;};
      };

      lsp = import ./nvim/lsp.nix {inherit lib;};
      languages = import ./nvim/languages.nix;

      treesitter = {
        enable = true;
        fold = false;
        highlight = {
          enable = true;
        };
        textobjects.enable = true;
        # autotagHtml = true;
        autotagHtml = true;
        addDefaultGrammars = false;
        grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          nix
          haskell
          elixir
          heex
          eex
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

          sources.default = [
            "lsp"
            "path"
            "snippets"
            "buffer"
            "codecompanion"
          ];

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
            numbers = "none";
            close_command = "bdelete! %d";
            middle_mouse_command = "bdelete! %d";
            left_mouse_command = "buffer %d";
            right_mouse_command = "bdelete! %d";
            indicator = {
              style = "icon";
              icon = "▎";
            };
            buffer_close_icon = "󰅖";
            close_icon = "󰅖";
            modified_icon = "●";
            left_trunc_marker = "";
            max_name_length = 22;
            max_prefix_length = 15;
            tab_size = 18;
            themable = true;
            diagnostics = "nvim_lsp";
            diagnostics_update_in_insert = false;
            diagnostics_indicator = mkLuaInline ''
              function(count, level, diagnostics_dict, context)
              	return "(" .. count .. ")"
              end


            '';
            color_icons = true;
            show_buffer_icons = true;
            show_buffer_close_icons = true;
            show_close_icon = true;
            show_tab_indicators = true;
            persist_buffer_sort = true;
            always_show_bufferline = true;
            enforce_regular_tabs = false;
            sort_by = "directory";
            hover.enabled = true;
            truncate_names = true;
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
            breadcrumb = "";
            separator = "";
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
      assistant.codecompanion-nvim = import ./nvim/code-companion.nix {
        inherit isWorkMacbook lib;
      };
    };
  };
}
