# Elixir language settings.
# LSP is handled by dexter (see dexter.nix / dexter-lsp.nix) wired up via
# extraLuaFiles in nvf.nix, rather than the nvf languages.elixir.lsp option.
{
  elixir = {
    enable = true;
    lsp.enable = false;
  };
}
