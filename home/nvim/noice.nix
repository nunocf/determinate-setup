{
  enable = true;
  setupOpts = {
    lsp = {
      progress.enabled = true;
      signature.enabled = true;
      hover.enabled = true;
    };
    presets = {
      bottom_search = true;
      command_palette = true;
      long_message_to_split = true;
      inc_rename = false;
      lsp_doc_border = true;
    };
    notify.enabled = true;
  };
}
