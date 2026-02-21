{
  enable = true;
  setupOpts = {
    options = {
      indicator.style = "icon";
      separator_style = "thin";
      show_filename_only = true;
      numbers = "none";
      diagnostics = false;
    };
  };
  mappings = {
    cycleNext = "<leader>n";
    cyclePrevious = "<leader>N";
    closeCurrent = "<leader>bn";
  };
}
