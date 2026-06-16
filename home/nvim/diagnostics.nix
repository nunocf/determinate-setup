# Diagnostic display config + linter setup.
# Runtime diagnostic behaviour (float toggling, etc.) lives in config/diagnostics.lua.
{
  pkgs,
  lib,
}: {
  config = {
    severity_sort = true;
    signs = true;
    underline = true;
    update_in_insert = false;
    virtual_text = false;
    float = {
      border = "single";
      source = "if_many";
      focusable = false;
      header = "";
      wrap = true;
      width = 72;
      max_width = 84;
    };
  };
  nvim-lint = import ./lint.nix {inherit pkgs lib;};
}
