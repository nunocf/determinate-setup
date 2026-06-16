{
  enable = true;
  friendly-snippets.enable = true;

  setupOpts = {
    snippets.preset = "default";

    sources.default = [
      "lsp"
      "path"
      "snippets"
      "buffer"
      "codecompanion"
    ];

    completion = {
      accept.auto_brackets.enabled = true;
      list.selection.preselect = true;
      documentation = {
        auto_show = true;
        auto_show_delay_ms = 200;
      };
    };

    keymap = {
      preset = "super-tab";
      "<C-y>" = ["select_and_accept"];
    };

    cmdline = {
      enabled = true;
      keymap.preset = "cmdline";
    };
  };
}
