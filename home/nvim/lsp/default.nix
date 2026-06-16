{
  enable = true;

  trouble = {
    enable = true;

    setupOpts = {
      focus = true;
      win.position = "right";
      multiline = true;
      warn_no_results = false;

      modes.diagnostics = {
        auto_open = false;
        auto_close = true;
      };
    };
  };

  formatOnSave = false;
}
