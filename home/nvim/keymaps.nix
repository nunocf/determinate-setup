[
  # Leader key legend
  # q = quit/session/home
  # f = files/find
  # g = git/build
  # l = lsp navigation
  # c = code/change/actions
  # x = diagnostics/lists
  # w = windows
  # u = utilities/toggles
  # s = surface/ui
  # a = apps/agents
  {
    key = "<leader>qh";
    mode = "n";
    action = "<cmd>lua Snacks.dashboard()<cr>";
    desc = "Home dashboard";
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
    key = "<leader>/";
    mode = "n";
    action = "<cmd>lua Snacks.picker.lines()<cr>";
    desc = "Search buffer lines";
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
  {
    key = "<leader>fe";
    mode = "n";
    action = "<cmd>lua Snacks.explorer()<cr>";
    desc = "Explorer";
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
    key = "<leader>gu";
    mode = "n";
    action = "<cmd>Gitsigns undo_stage_hunk<cr>";
    desc = "Undo stage hunk";
  }
  {
    key = "<leader>gd";
    mode = "n";
    action = "<cmd>Gitsigns preview_hunk<cr>";
    desc = "Preview hunk";
  }
  {
    key = "<leader>gD";
    mode = "n";
    action = "<cmd>Gitsigns diffthis<cr>";
    desc = "Diff this";
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
    key = "<leader>xn";
    mode = "n";
    silent = true;
    action = "<cmd>lua vim.diagnostic.jump({count = 1, float = _G.diagnostic_float_opts()})<cr>";
    desc = "Next diagnostic";
  }
  {
    key = "<leader>xp";
    mode = "n";
    silent = true;
    action = "<cmd>lua vim.diagnostic.jump({count = -1, float = _G.diagnostic_float_opts()})<cr>";
    desc = "Previous diagnostic";
  }

  {
    key = "<leader>xN";
    mode = "n";
    silent = true;
    action = "<cmd>lua vim.diagnostic.jump({count = 1, severity = vim.diagnostic.severity.ERROR, float = _G.diagnostic_float_opts()})<cr>";
    desc = "Next error";
  }
  {
    key = "<leader>xP";
    mode = "n";
    silent = true;
    action = "<cmd>lua vim.diagnostic.jump({count = -1, severity = vim.diagnostic.severity.ERROR, float = _G.diagnostic_float_opts()})<cr>";
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
  {
    key = "<leader>xd";
    mode = "n";
    action = "<cmd>lua (function() local diags = vim.diagnostic.get(0); if vim.tbl_isempty(diags) then vim.notify('No diagnostics in this buffer'); return end; local cursor = vim.api.nvim_win_get_cursor(0); local line = cursor[1] - 1; local line_diags = vim.diagnostic.get(0, { lnum = line }); local target = line_diags[1] or diags[1]; vim.diagnostic.jump({ diagnostic = target, float = _G.diagnostic_float_opts() }) end)()<cr>";
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
    key = "<leader>lD";
    mode = "n";
    action = "<cmd>lua vim.lsp.buf.declaration()<cr>";
    desc = "Declaration";
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
    key = "<leader>lt";
    mode = "n";
    action = "<cmd>lua vim.lsp.buf.type_definition()<cr>";
    desc = "Type definition";
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
    key = "<leader>ct";
    mode = "n";
    action = "<cmd>lua vim.lsp.buf.code_action({ context = { only = { 'refactor', 'quickfix' } } })<cr>";
    desc = "Type/signature actions";
  }
  {
    key = "dd";
    mode = "n";
    action = ''"+dd'';
    desc = "Delete line to system clipboard";
  }
  {
    key = "d";
    mode = ["n" "v"];
    action = ''"+d'';
    desc = "Delete to system clipboard";
  }
  {
    key = "<leader>cF";
    mode = "n";
    action = "<cmd>lua format_buffer_now()<cr>";
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
    key = "<leader>bD";
    mode = "n";
    action = "<cmd>BufferLinePickClose<cr>";
    desc = "Pick buffer to close";
  }
  {
    key = "<leader>bn";
    mode = "n";
    action = "<cmd>BufferLineCycleNext<cr>";
    desc = "Next buffer";
  }
  {
    key = "<leader>bp";
    mode = "n";
    action = "<cmd>BufferLineCyclePrev<cr>";
    desc = "Previous buffer";
  }
  {
    key = "<leader>bo";
    mode = "n";
    action = "<cmd>BufferLineCloseOthers<cr>";
    desc = "Close other buffers";
  }
  {
    key = "<leader>br";
    mode = "n";
    action = "<cmd>BufferLinePick<cr>";
    desc = "Pick buffer";
  }
  {
    key = "<leader>bl";
    mode = "n";
    action = "<cmd>BufferLineMoveNext<cr>";
    desc = "Move buffer right";
  }
  {
    key = "<leader>bh";
    mode = "n";
    action = "<cmd>BufferLineMovePrev<cr>";
    desc = "Move buffer left";
  }
  {
    key = "<leader>bb";
    mode = "n";
    action = "<cmd>BufferLineTogglePin<cr>";
    desc = "Toggle buffer pin";
  }
  {
    key = "<S-h>";
    mode = "n";
    action = "<cmd>BufferLineCyclePrev<cr>";
    desc = "Previous buffer";
  }
  {
    key = "<S-l>";
    mode = "n";
    action = "<cmd>BufferLineCycleNext<cr>";
    desc = "Next buffer";
  }

  ############################################################
  # CLIPBOARD
  ############################################################

  {
    key = "y";
    mode = ["n" "v"];
    action = ''"+y'';
    desc = "Yank to system clipboard";
  }
  {
    key = "Y";
    mode = "n";
    action = ''"+Y'';
    desc = "Yank line to system clipboard";
  }
  {
    key = "p";
    mode = "n";
    action = ''"+p'';
    desc = "Paste from system clipboard";
  }
  {
    key = "P";
    mode = "n";
    action = ''"+P'';
    desc = "Paste before from system clipboard";
  }
  {
    key = "p";
    mode = "v";
    action = ''"_d"+P'';
    desc = "Paste over selection from system clipboard";
  }
  {
    key = "P";
    mode = "v";
    action = ''"_d"+P'';
    desc = "Paste over selection from system clipboard";
  }
  {
    key = "d";
    mode = ["n" "v"];
    action = ''"+d'';
    desc = "Delete to system clipboard";
  }
  {
    key = "D";
    mode = "n";
    action = ''"+D'';
    desc = "Delete to end to system clipboard";
  }
  {
    key = "c";
    mode = ["n" "v"];
    action = ''"+c'';
    desc = "Change to system clipboard";
  }
  {
    key = "C";
    mode = "n";
    action = ''"+C'';
    desc = "Change to end to system clipboard";
  }
  {
    key = "x";
    mode = ["n" "v"];
    action = ''"+x'';
    desc = "Delete char to system clipboard";
  }
  {
    key = "X";
    mode = "n";
    action = ''"+X'';
    desc = "Backspace char to system clipboard";
  }
  {
    key = "s";
    mode = ["n" "v"];
    action = ''"_s'';
    desc = "Substitute without yanking";
  }
  {
    key = "S";
    mode = ["n" "v"];
    action = ''"_S'';
    desc = "Substitute line without yanking";
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
    key = "<C-h>";
    mode = "n";
    action = "<C-w>h";
    desc = "Window left";
  }
  {
    key = "<C-j>";
    mode = "n";
    action = "<C-w>j";
    desc = "Window down";
  }
  {
    key = "<C-k>";
    mode = "n";
    action = "<C-w>k";
    desc = "Window up";
  }
  {
    key = "<C-l>";
    mode = "n";
    action = "<C-w>l";
    desc = "Window right";
  }
  {
    key = "<leader>ww";
    mode = "n";
    action = "<C-W>w";
    desc = "Next window";
  }
  {
    key = "<leader>w=";
    mode = "n";
    action = "<C-W>=";
    desc = "Balance windows";
  }
  {
    key = "<leader>w,";
    mode = "n";
    action = "<cmd>vertical resize -5<cr>";
    desc = "Window narrower";
  }
  {
    key = "<leader>w.";
    mode = "n";
    action = "<cmd>vertical resize +5<cr>";
    desc = "Window wider";
  }
  {
    key = "<leader>w-";
    mode = "n";
    action = "<cmd>resize -3<cr>";
    desc = "Window shorter";
  }
  {
    key = "<leader>w+";
    mode = "n";
    action = "<cmd>resize +3<cr>";
    desc = "Window taller";
  }

  ############################################################
  # LISTS
  ############################################################

  {
    key = "]q";
    mode = "n";
    action = "<cmd>cnext<cr>";
    desc = "Next quickfix";
  }
  {
    key = "[q";
    mode = "n";
    action = "<cmd>cprev<cr>";
    desc = "Previous quickfix";
  }
  {
    key = "]l";
    mode = "n";
    action = "<cmd>lnext<cr>";
    desc = "Next location";
  }
  {
    key = "[l";
    mode = "n";
    action = "<cmd>lprev<cr>";
    desc = "Previous location";
  }
  {
    key = "<leader>xq";
    mode = "n";
    action = "<cmd>copen<cr>";
    desc = "Quickfix list";
  }
  {
    key = "<leader>xl";
    mode = "n";
    action = "<cmd>lopen<cr>";
    desc = "Location list";
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
    key = "<leader>sh";
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
  {
    key = "j";
    mode = "n";
    action = "v:count == 0 ? 'gj' : 'j'";
    desc = "Down by display line";
    expr = true;
  }
  {
    key = "k";
    mode = "n";
    action = "v:count == 0 ? 'gk' : 'k'";
    desc = "Up by display line";
    expr = true;
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
    key = "_";
    mode = "n";
    action = "<cmd>Oil<cr>";
    desc = "Oil (cwd)";
    silent = true;
    noremap = true;
  }
  {
    key = "<leader>ac";
    mode = "n";
    silent = true;
    action = "<cmd>CodeCompanionChat Toggle<CR>";
    desc = "CodeCompanion chat";
  }
  {
    key = "<leader>ab";
    mode = "n";
    silent = true;
    action = "<cmd>CodeCompanionChat #{buffer}<CR>";
    desc = "Chat with buffer";
  }
  {
    key = "<leader>aa";
    mode = "n";
    silent = true;
    action = "<cmd>CodeCompanionActions<CR>";
    desc = "CodeCompanion actions";
  }
  {
    key = "<leader>ai";
    mode = ["n" "v"];
    silent = true;
    action = "<cmd>CodeCompanion<CR>";
    desc = "CodeCompanion inline";
  }
  {
    key = "<leader>at";
    mode = "n";
    silent = true;
    action = "<cmd>lua toggle_codex()<CR>";
    desc = "Codex terminal";
  }
]
