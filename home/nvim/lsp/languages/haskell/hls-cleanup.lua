-- Overrides the HLS command to use the wrapper found in PATH, so that project
-- dev-shells can supply the correct HLS version at runtime.
-- Loaded via luaConfigRC.haskell-tools-cleanup (entryAfter haskell-tools-nvim)
-- in nvf.nix, which ensures this runs after the plugin has initialised.
local wrapper = vim.fn.exepath("haskell-language-server-wrapper")
if wrapper ~= "" then
	local ht = vim.g.haskell_tools
	if type(ht) ~= "table" then
		ht = {}
	end
	if type(ht.hls) ~= "table" then
		ht.hls = {}
	end

	ht.hls.root_dir = nil
	ht.hls.enable = nil
	ht.hls.filetypes = nil

	if type(ht.tools) ~= "table" then
		ht.tools = {}
	end
	if type(ht.tools.hover) ~= "table" then
		ht.tools.hover = {}
	end
	ht.tools.hover.enable = nil

	ht.hls.cmd = {
		wrapper,
		"--lsp",
	}

	vim.g.haskell_tools = ht
end
