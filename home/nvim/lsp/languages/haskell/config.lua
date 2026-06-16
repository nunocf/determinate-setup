-- Haskell LSP runtime configuration.
-- Loaded via extraLuaFiles at startup (before plugins).
-- hls-cleanup.lua runs after haskell-tools-nvim via luaConfigRC ordering.

-- Clear haskell-tools-nvim fields that would otherwise override our own setup.
do
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

	vim.g.haskell_tools = ht
end

-- Enable hlint diagnostics and code actions via haskell-tools-nvim.
do
	local ht = vim.g.haskell_tools
	if type(ht) ~= "table" then
		ht = {}
	end
	if type(ht.hls) ~= "table" then
		ht.hls = {}
	end
	if type(ht.hls.settings) ~= "table" then
		ht.hls.settings = {}
	end

	local hs = ht.hls.settings.haskell
	if type(hs) ~= "table" then
		hs = {}
		ht.hls.settings.haskell = hs
	end

	if type(hs.plugin) ~= "table" then
		hs.plugin = {}
	end
	if type(hs.plugin.hlint) ~= "table" then
		hs.plugin.hlint = {}
	end

	hs.plugin.hlint.globalOn = true
	hs.plugin.hlint.diagnosticsOn = true
	hs.plugin.hlint.codeActionsOn = true

	vim.g.haskell_tools = ht
end

local function warn_missing_hls()
	if vim.bo.buftype ~= "" then
		return
	end

	local filetype = vim.bo.filetype
	if filetype ~= "haskell" and filetype ~= "lhaskell" then
		return
	end

	if vim.fn.exepath("haskell-language-server-wrapper") ~= "" then
		return
	end

	if vim.b._warned_missing_hls then
		return
	end

	vim.b._warned_missing_hls = true
	vim.schedule(function()
		vim.notify(
			"Haskell LSP is not available in this session. Start Neovim from the project dev shell so it can use the project HLS.",
			vim.log.levels.WARN
		)
	end)
end

vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, {
	pattern = { "*.hs", "*.lhs", "haskell", "lhaskell" },
	callback = warn_missing_hls,
})

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "FileType" }, {
	pattern = { "*.hs", "*.lhs", "haskell", "lhaskell" },
	callback = function(args)
		pcall(vim.treesitter.start, args.buf, "haskell")
	end,
})

local function refresh_haskell_diagnostics(bufnr)
	for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
		if client.supports_method and client:supports_method("workspace/diagnostic/refresh") then
			pcall(client.request, client, "workspace/diagnostic/refresh", {}, function() end, bufnr)
		end
	end
end

vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "InsertLeave", "BufWritePost" }, {
	pattern = { "*.hs", "*.lhs", "haskell", "lhaskell" },
	callback = function(args)
		refresh_haskell_diagnostics(args.buf)
	end,
})
