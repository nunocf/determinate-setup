{pkgs, ...}: {
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
      };
      globals.mapleader = ",";

      keymaps = import ./nvim/keymaps.nix;
      viAlias = true;
      vimAlias = true;

      lsp = {
        enable = true;
        otter-nvim.enable = true;
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
      };

      formatter.conform-nvim.enable = true;
      # telescope.enable = true;

      autopairs.nvim-autopairs.enable = true;

      autocomplete.nvim-cmp.enable = true;
      lineNumberMode = "number";

      visuals = {
        nvim-cursorline = {
          enable = true;
          setupOpts = {
            cursorline.enable = true;
            cursorword.enable = true;
          };
        };
        nvim-web-devicons.enable = true;
        fidget-nvim.enable = true;
      };
      ui.noice.enable = true;

      terminal.toggleterm = {
        enable = true;
        setupOpts = {direction = "float";};
        mappings.open = "<leader>t";
        lazygit = {
          enable = true;
        };
      };

      binds.whichKey = {
        enable = true;
        register = {
          # "<leader>f" = "Find";
          # "<leader>g" = "Git";
          # "<leader>v" = "Splits";
          # "gc" = "Comment";
          # "gz" = "Folds";
        };
        setupOpts = {
          show_help = false;
          operators_ignore = ["gc" "gz" "gZ" "i" "a"];
        };
      };
      statusline.lualine = import ./nvim/lualine.nix;
      tabline.nvimBufferline = import ./nvim/bufferline.nix;
      utility = {
        motion.flash-nvim = import ./nvim/flash.nix;
        surround.enable = true;
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
    };
  };
}
