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
        otter-nvim.enable = true;
        null-ls.enable = true;
      };
      languages = {
        enableFormat = true;
        enableTreesitter = true;
        nix = {
          enable = true;
          format.enable = true;
        };
        markdown.enable = true;
        haskell.enable = true;
        lua.enable = true;
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
      terminal.toggleterm = {
        enable = true;
        setupOpts = {direction = "float";};
        mappings.open = "<leader>t";
        lazygit = {
          enable = true;
        };
      };

      binds.whichKey.enable = true;
      statusline.lualine = import ./nvim/lualine.nix;
      tabline.nvimBufferline = import ./nvim/bufferline.nix;
      mini = import ./nvim/mini.nix;
    };
  };
}
