# Generates Lua that registers and enables the dexter LSP server.
# dexter binary: prefer PATH (project dev-shell), fall back to the Nix store build.
{
  pkgs,
  dexterPkg,
}:
pkgs.writeText "nvf-dexter-lsp.lua" ''
  do
  	local cmd = vim.fn.exepath("dexter")
  	if cmd == nil or cmd == "" then
  		cmd = "${dexterPkg}/bin/dexter"
  	end

  	vim.lsp.config("dexter", {
  		cmd = { cmd, "lsp" },
  		filetypes = { "elixir", "eelixir", "heex" },
  		root_markers = { ".dexter/dexter.db", ".dexter.db", ".git", "mix.exs" },
  		init_options = {
  			followDelegates = true,
  		},
  	})
  	vim.lsp.enable("dexter")
  end
''
