[
  # Window splits
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
  # Oil
  {
    key = "-";
    mode = "n";
    action = "<CMD>Oil --float<CR>";
    silent = true;
    desc = "Open Oil in a floating window";
  }
  # Picker
  # Group label (this creates the "Find" header in which-key)
  {
    mode = "n";
    key = "<leader>f";
    action = "<cmd>WhichKey<cr>";
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
]
