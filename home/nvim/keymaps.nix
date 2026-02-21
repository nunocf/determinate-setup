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
]
