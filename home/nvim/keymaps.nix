[
  # Window splits

  {
    key = "<leader>v";
    mode = "n";
    action = "";
    desc = "Splits";
  }
  {
    key = "<leader>vr";
    mode = "n";
    action = "<C-W>v";
    desc = "Split window right";
  }
  {
    key = "<leader>vb";
    mode = "n";
    action = "<C-W>s";
    desc = "Split window below";
  }
  # Oil
  {
    key = "-";
    mode = "n";
    action = "<CMD>Oil --float<CR>";
    silent = true;
    desc = "Open Oil in a floating window";
  }
  # Picker

  # Group label
  {
    mode = "n";
    key = "<leader>f";
    action = "";
    desc = "Find";
  }
  # Actual picker mappings
  {
    mode = "n";
    key = "<leader>ff";
    action = "<cmd>lua Snacks.picker.files()<cr>";
    desc = "Files";
  }

  {
    mode = "n";
    key = "<leader>fg";
    action = "<cmd>lua Snacks.picker.grep()<cr>";
    desc = "Live grep";
  }
  {
    mode = "n";
    key = "<leader>fb";
    action = "<cmd>lua Snacks.picker.buffers()<cr>";
    desc = "Buffers";
  }

  {
    mode = "n";
    key = "<leader>fr";
    action = "<cmd>lua Snacks.picker.recent()<cr>";
    desc = "Recent files";
  }

  # Git (example)
  {
    mode = "n";
    key = "<leader>g";
    action = "";
    desc = "Git";
  }
  # Comment
  {
    mode = "n";
    key = "gc";
    action = "";
    desc = "Comment";
  }
  #Folds
  {
    mode = "n";
    key = "gz";
    action = "";
    desc = "Folds";
  }
  # Noice group
  {
    key = "<leader>sn";
    mode = "n";
    action = "";
    desc = "Noice";
  }

  {
    key = "<leader>snl";
    mode = "n";
    action = "<cmd>Noice last<cr>";
    desc = "Noice Last Message";
  }

  {
    key = "<leader>snh";
    mode = "n";
    action = "<cmd>Noice history<cr>";
    desc = "Noice History";
  }

  {
    key = "<leader>sna";
    mode = "n";
    action = "<cmd>Noice all<cr>";
    desc = "Noice All";
  }

  {
    key = "<leader>snd";
    mode = "n";
    action = "<cmd>Noice dismiss<cr>";
    desc = "Dismiss Notifications";
  }
  # Trouble group
  {
    key = "<leader>x";
    mode = "n";
    action = "";
    desc = "Diagnostics";
  }

  {
    key = "<leader>xx";
    mode = "n";
    action = "<cmd>Trouble diagnostics toggle<cr>";
    desc = "Diagnostics";
  }

  {
    key = "<leader>xw";
    mode = "n";
    action = "<cmd>Trouble workspace_diagnostics<cr>";
    desc = "Workspace Diagnostics";
  }

  {
    key = "<leader>xd";
    mode = "n";
    action = "<cmd>Trouble document_diagnostics<cr>";
    desc = "Document Diagnostics";
  }

  {
    key = "<leader>xq";
    mode = "n";
    action = "<cmd>Trouble quickfix<cr>";
    desc = "Quickfix";
  }
]
