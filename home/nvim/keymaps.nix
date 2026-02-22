[
  {
    key = "<leader><leader>";
    mode = "n";
    action = "<cmd>LeaderDashboard<cr>";
    desc = "Leader dashboard";
  }
  {
    key = "<leader><leader>";
    mode = "n";
    action = "<cmd>LeaderDashboard<cr>";
    desc = "Command palette";
  }
  ############################################################
  # FILES / SEARCH
  ############################################################

  {
    key = "<leader>ff";
    mode = "n";
    action = "<cmd>lua Snacks.picker.files()<cr>";
    desc = "Find files";
  }
  {
    key = "<leader>fg";
    mode = "n";
    action = "<cmd>lua Snacks.picker.grep()<cr>";
    desc = "Live grep";
  }
  {
    key = "<leader>fb";
    mode = "n";
    action = "<cmd>lua Snacks.picker.buffers()<cr>";
    desc = "Buffers";
  }
  {
    key = "<leader>fr";
    mode = "n";
    action = "<cmd>lua Snacks.picker.recent()<cr>";
    desc = "Recent files";
  }

  ############################################################
  # GIT / BUILD
  ############################################################

  {
    key = "<leader>gt";
    mode = "n";
    action = "<cmd>SmartGhcid<cr>";
    desc = "Run ghcid";
  }
  {
    key = "<leader>gl";
    mode = "n";
    action = "<cmd>LazyGit<cr>";
    desc = "LazyGit";
  }

  ############################################################
  # DIAGNOSTICS / ERRORS
  ############################################################

  {
    key = "<leader>xn";
    mode = "n";
    silent = true;
    action = ''
      function()
        vim.diagnostic.goto_next({severity=vim.diagnostic.severity.ERROR})
        vim.diagnostic.open_float(nil,{focus=false})
      end
    '';
    desc = "Next error";
  }

  {
    key = "<leader>xp";
    mode = "n";
    silent = true;
    action = ''
      function()
        vim.diagnostic.goto_prev({severity=vim.diagnostic.severity.ERROR})
        vim.diagnostic.open_float(nil,{focus=false})
      end
    '';
    desc = "Previous error";
  }

  {
    key = "<leader>xx";
    mode = "n";
    action = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>";
    desc = "Trouble buffer";
  }
  {
    key = "<leader>xX";
    mode = "n";
    action = "<cmd>Trouble diagnostics toggle<cr>";
    desc = "Trouble workspace";
  }

  ############################################################
  # LSP NAVIGATION
  ############################################################

  {
    key = "<leader>ld";
    mode = "n";
    action = "<cmd>lua vim.lsp.buf.definition()<cr>";
    desc = "Definition";
  }
  {
    key = "<leader>lr";
    mode = "n";
    action = "<cmd>lua vim.lsp.buf.references()<cr>";
    desc = "References";
  }
  {
    key = "<leader>lh";
    mode = "n";
    action = "<cmd>lua vim.lsp.buf.hover()<cr>";
    desc = "Hover";
  }
  {
    key = "<leader>li";
    mode = "n";
    action = "<cmd>lua vim.lsp.buf.implementation()<cr>";
    desc = "Implementation";
  }

  ############################################################
  # CODE ACTIONS / REFACTOR
  ############################################################

  {
    key = "<leader>ca";
    mode = "n";
    action = "<cmd>lua vim.lsp.buf.code_action()<cr>";
    desc = "Code action";
  }
  {
    key = "<leader>cr";
    mode = "n";
    action = "<cmd>lua vim.lsp.buf.rename()<cr>";
    desc = "Rename";
  }
  {
    key = "<leader>cf";
    mode = "n";
    action = "<cmd>lua vim.lsp.buf.format()<cr>";
    desc = "Format";
  }

  ############################################################
  # BUFFERS
  ############################################################

  {
    key = "<leader>bd";
    mode = "n";
    action = "<cmd>bdelete<cr>";
    desc = "Delete buffer";
  }
  {
    key = "<leader>bn";
    mode = "n";
    action = "<cmd>bnext<cr>";
    desc = "Next buffer";
  }
  {
    key = "<leader>bp";
    mode = "n";
    action = "<cmd>bprevious<cr>";
    desc = "Previous buffer";
  }

  ############################################################
  # WINDOWS
  ############################################################

  {
    key = "<leader>ws";
    mode = "n";
    action = "<C-W>s";
    desc = "Split below";
  }
  {
    key = "<leader>wv";
    mode = "n";
    action = "<C-W>v";
    desc = "Split right";
  }
  {
    key = "<leader>wd";
    mode = "n";
    action = "<C-W>c";
    desc = "Close window";
  }
  {
    key = "<leader>ww";
    mode = "n";
    action = "<C-W>w";
    desc = "Next window";
  }

  ############################################################
  # UTILITIES / TOOLS
  ############################################################

  {
    key = "<leader>uh";
    mode = "n";
    action = "<cmd>checkhealth<cr>";
    desc = "Check health";
  }

  ############################################################
  # UI / TOGGLES
  ############################################################

  {
    key = "<leader>sn";
    mode = "n";
    action = "<cmd>Noice history<cr>";
    desc = "Noice history";
  }

  ############################################################
  # QUIT / SESSION
  ############################################################

  {
    key = "<leader>qq";
    mode = "n";
    action = "<cmd>qa<cr>";
    desc = "Quit all";
  }
  {
    key = "<leader>wq";
    mode = "n";
    action = "<cmd>wq<cr>";
    desc = "Save & quit";
  }
  ############################################################
  # MISC
  ############################################################
  # Visual stay in indent mode after < or >
  {
    action = "<gv";
    key = "<";
    mode = "v";
  }
  {
    action = ">gv";
    key = ">";
    mode = "v";
  }

  # stop highlighting with <CR>
  {
    action = "<cmd>nohl<CR>";
    key = "<CR>";
    mode = "n";
    desc = "Clear search highlight";
    noremap = true;
  }
  {
    key = "K";
    mode = "n";
    action = "<cmd>lua vim.lsp.buf.hover()<cr>";
    desc = "Hover documentation";
  }
]
