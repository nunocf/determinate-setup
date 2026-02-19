{
  programs.nvf = {
    enable = true;
    settings.vim = {
      theme = {
        enable = true;
        name = "everforest";
        style = "hard";
      };
      options = {
        tabstop = 2;
        shiftwidth = 2;
        expandtab = true;
        smartindent = true;
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
        encoding = "utf-8";
        fileencoding = "utf-8";
      };
      globals.mapleader = ",";

      keymaps = [
        {
          key = "<leader>vr";
          mode = "n";
          action = "<C-W>v";
          silent = true;
          desc = "Split window right";
        }
        {
          key = "<leader>vb";
          mode = "n";
          action = "<C-W>s";
          silent = true;
          desc = "Split window below";
        }
      ];

      viAlias = true;
      vimAlias = true;

      lsp = {
        enable = true;
        formatOnSave = true;

      };
      languages = {
        nix = {
          enable = true;
        };

        markdown.enable = true;
        haskell.enable = true;
      };

      clipboard = {
        enable = true;
        registers = "unnamedplus";
      };

      treesitter = {
        enable = true;
        indent.enable = true;
      };

      formatter.conform-nvim.enable = true;
      telescope.enable = true;
      statusline.lualine = {
        enable = true;
        theme = "everforest";
        # Git branch
        activeSection.b = [
          ''{ "branch", icon = ' ', colored = true, separator = {right = ''}, padding = { left = 1, right = 1 } } ''
        ];

        # Diff
        activeSection.c = [
          ''
            {
                  "diff",
                  symbols = { added = " ", modified = " ", removed = " " },
                  diff_color = { added = "DiffAdd", modified = "DiffChange", removed = "DiffDelete" },
                  separator = { right = '' },
                  padding = { left = 1, right = 1 }
                }''
          ''
            {
                  "diagnostics",
                  symbols = { error = "", warn = "", info = "", hint = "󰌵" },
                  diagnostics_color = {
                    error = "DiagnosticError",
                    warn  = "DiagnosticWarn",
                    info  = "DiagnosticInfo",
                    hint  = "DiagnosticHint"
                  },
                  separator = { right = '' },
                  padding = { left = 1, right = 1 }
                }''
        ];

        # Search + Filetype + encoding
        activeSection.y = [
          ''
            {
                  "searchcount", maxcount = 999, timeout = 120,
                  icons_enabled = true, icon = "",
                  padding = { left = 1, right = 1 }
                }''
          ''
            {
                  "encoding",
                  icons_enabled = true,
                  padding = { left = 1, right = 1 }
                }
          ''
          ''
            {
                  "filetype",
                  icons_enabled = true,
                  colored = true,
                  padding = { left = 1, right = 1 }
                }
          ''
        ];
        activeSection.z = [
          ''{ "", draw_empty = true, separator = { left = '', right = '' } } ''
          ''{ "progress", separator = {left = ''} } ''
          ''{"location"} ''
        ];
      };

      autopairs.nvim-autopairs.enable = true;

      autocomplete.nvim-cmp.enable = true;
      lineNumberMode = "number";

      visuals = {
        indent-blankline.enable = true;
        nvim-cursorline = {
          enable = true;
          setupOpts = {
            cursorline.enable = true;
            cursorword.enable = true;
          };
        };
        nvim-web-devicons.enable = true;
      };

      binds.whichKey.enable = true;
    };
  };
}
