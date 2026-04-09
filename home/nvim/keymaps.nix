[
  {
    key = "<leader><leader>";
    mode = "n";
    action = "<cmd>lua Snacks.dashboard()<cr>";
    desc = "Dashboard";
  }
  ############################################################
  # FILES / SEARCH
  ############################################################

  {
    key = "<leader>ff";
    mode = "n";
    action = "<cmd>lua Snacks.picker.files({ cwd = project_root() })<cr>";
    desc = "Files (project)";
  }
  {
    key = "<leader>fF";
    mode = "n";
    action = "<cmd>lua Snacks.picker.files({ cwd = vim.fn.getcwd() })<cr>";
    desc = "Files (cwd)";
  }
  {
    key = "<leader>fg";
    mode = "n";
    action = "<cmd>lua Snacks.picker.grep({ cwd = project_root() })<cr>";
    desc = "Grep (project)";
  }
  {
    key = "<leader>fw";
    mode = "n";
    action = "<cmd>lua Snacks.picker.grep_word({ cwd = project_root() })<cr>";
    desc = "Word under cursor";
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
  {
    key = "<leader>fP";
    mode = "n";
    action = "<cmd>lua Snacks.picker.projects()<cr>";
    desc = "Projects";
  }
  {
    key = "<leader>fp";
    mode = "n";
    action = "<cmd>lua Snacks.picker.resume()<cr>";
    desc = "Resume picker";
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
  {
    key = "]h";
    mode = "n";
    action = "<cmd>Gitsigns next_hunk<cr>";
    desc = "Next hunk";
  }
  {
    key = "[h";
    mode = "n";
    action = "<cmd>Gitsigns prev_hunk<cr>";
    desc = "Previous hunk";
  }
  {
    key = "<leader>gs";
    mode = "n";
    action = "<cmd>Gitsigns stage_hunk<cr>";
    desc = "Stage hunk";
  }
  {
    key = "<leader>gr";
    mode = "n";
    action = "<cmd>Gitsigns reset_hunk<cr>";
    desc = "Reset hunk";
  }
  {
    key = "<leader>gS";
    mode = "n";
    action = "<cmd>Gitsigns stage_buffer<cr>";
    desc = "Stage buffer";
  }
  {
    key = "<leader>gb";
    mode = "n";
    action = "<cmd>Gitsigns blame_line<cr>";
    desc = "Blame line";
  }
  {
    key = "<leader>gB";
    mode = "n";
    action = "<cmd>Gitsigns toggle_current_line_blame<cr>";
    desc = "Toggle line blame";
  }
  {
    key = "<leader>gd";
    mode = "n";
    action = "<cmd>Gitsigns preview_hunk<cr>";
    desc = "Preview hunk";
  }
  {
    key = "<leader>gp";
    mode = "n";
    action = "<cmd>lua Snacks.picker.git_status()<cr>";
    desc = "Git status";
  }

  ############################################################
  # DIAGNOSTICS / ERRORS
  ############################################################

  {
    key = "]e";
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
    key = "]d";
    mode = "n";
    silent = true;
    action = ''
      function()
        vim.diagnostic.goto_next()
        vim.diagnostic.open_float(nil,{focus=false})
      end
    '';
    desc = "Next diagnostic";
  }

  {
    key = "[e";
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
    key = "[d";
    mode = "n";
    silent = true;
    action = ''
      function()
        vim.diagnostic.goto_prev()
        vim.diagnostic.open_float(nil,{focus=false})
      end
    '';
    desc = "Previous diagnostic";
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
  {
    key = "<leader>xd";
    mode = "n";
    action = "<cmd>lua vim.diagnostic.open_float(nil, { focus = false, scope = 'cursor' })<cr>";
    desc = "Diagnostic (cursor)";
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
    action = "<cmd>lua Snacks.picker.lsp_references()<cr>";
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
    action = "<cmd>lua Snacks.picker.lsp_implementations()<cr>";
    desc = "Implementation";
  }
  {
    key = "<leader>ls";
    mode = "n";
    action = "<cmd>lua Snacks.picker.lsp_symbols()<cr>";
    desc = "Document symbols";
  }
  {
    key = "<leader>lS";
    mode = "n";
    action = "<cmd>lua Snacks.picker.lsp_workspace_symbols()<cr>";
    desc = "Workspace symbols";
  }
  {
    key = "<leader>lq";
    mode = "n";
    action = "<cmd>lua Snacks.picker.diagnostics_buffer()<cr>";
    desc = "Buffer diagnostics";
  }
  {
    key = "<leader>lQ";
    mode = "n";
    action = "<cmd>lua Snacks.picker.diagnostics()<cr>";
    desc = "Workspace diagnostics";
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
    key = "<leader>cA";
    mode = "n";
    action = "<cmd>lua vim.lsp.buf.code_action({ apply = true })<cr>";
    desc = "Code action (apply if single)";
  }
  {
    key = "<leader>cR";
    mode = "n";
    action = "<cmd>lua vim.lsp.buf.rename()<cr>";
    desc = "Rename";
  }
  {
    key = "<leader>cr";
    mode = "n";
    action = "<cmd>lua vim.lsp.buf.code_action({ context = { only = { 'refactor.rewrite', 'quickfix' } } })<cr>";
    desc = "Code action (rewrite/quickfix)";
  }
  {
    key = "<leader>ts";
    mode = "n";
    action = "<cmd>lua vim.lsp.buf.code_action({ context = { only = { 'refactor', 'quickfix' } } })<cr>";
    desc = "Type/signature actions";
  }
  {
    key = "<leader>cf";
    mode = "n";
    action = "<cmd>lua require('conform').format({ async = true, lsp_format = 'never' })<cr>";
    desc = "Format buffer";
  }
  {
    key = "<leader>cS";
    mode = "n";
    action = "<cmd>lua vim.lsp.buf.code_action({ context = { only = { 'source', 'source.organizeImports' } } })<cr>";
    desc = "Code action (source)";
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
  {
    key = "<leader>ur";
    mode = "n";
    action = "<cmd>edit!<cr>";
    desc = "Reload buffer";
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
    key = "<leader>qr";
    mode = "n";
    action = "<cmd>lua Snacks.dashboard()<cr>";
    desc = "Return to dashboard";
  }
  {
    key = "<leader>qs";
    mode = "n";
    action = "<cmd>SessionSave<cr>";
    desc = "Save session";
  }
  {
    key = "<leader>ql";
    mode = "n";
    action = "<cmd>SessionLoad<cr>";
    desc = "Load session";
  }
  {
    key = "<leader>qd";
    mode = "n";
    action = "<cmd>SessionDelete<cr>";
    desc = "Delete session";
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
  {
    key = "-";
    mode = "n";
    action = "<cmd>Oil --float<cr>";
    desc = "Oil (float)";
    silent = true;
    noremap = true;
  }
  {
    key = "<leader>ac";
    mode = "n";
    silent = true;
    action = "<cmd>TermExec direction=vertical size=80 cmd='codex'<CR>";
    desc = "Toggle Codex";
  }
]
