# Lua language settings.
# lua-language-server is resolved shell-first via lspPathFirstLua in nvf.nix,
# falling back to the Nix store path.  lazydev provides completion for the
# Neovim API while editing Neovim config files.
{
  lua = {
    enable = true;
    lsp = {
      lazydev.enable = true;
      servers = ["lua-language-server"];
    };
  };
}
