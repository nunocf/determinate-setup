----------------------------------------------------------------
-- NVF / HASKELL-TOOLS: CLEAN LEGACY KEYS + ENABLE HLS HLINT DIAGNOSTICS/ACTIONS
----------------------------------------------------------------

-- Clean up NVF's legacy haskell-tools keys *before* the plugin reads vim.g.haskell_tools
do
	local ht = vim.g.haskell_tools
	if type(ht) ~= "table" then
		ht = {}
	end
	if type(ht.hls) ~= "table" then
		ht.hls = {}
	end

	-- These keys trigger warnings like:
	-- .haskell_tools: { "hls.root_dir", "hls.enable", "hls.filetypes" }
	ht.hls.root_dir = nil
	ht.hls.enable = nil
	ht.hls.filetypes = nil

	vim.g.haskell_tools = ht
end

-- Enable HLS hlint diagnostics + code actions
-- IMPORTANT: diagnosticsOn controls whether hlint hints appear as diagnostics (underlines/signs/etc).
-- codeActionsOn controls whether "Apply hint: ..." appears in code actions.
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

----------------------------------------------------------------
-- NIX: FORCE vim-nix indent (avoid TS indentexpr quirks)
----------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
	pattern = "nix",
	callback = function()
		-- Clear TS indentexpr if set
		vim.bo.indentexpr = ""
		vim.b.did_indent = nil

		-- Load the nix indent script (provided by vim-nix)
		vim.cmd("silent! runtime! indent/nix.vim")
	end,
})

----------------------------------------------------------------
-- GENERAL: DON’T AUTO-CONTINUE COMMENTS ON NEWLINE
----------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		vim.opt_local.formatoptions:remove({ "c", "r", "o" }) -- no auto comment on Enter/o/O
		vim.opt_local.formatoptions:append({ "j" }) -- remove comment leader when possible
	end,
})

----------------------------------------------------------------
-- PASTE MODE TOGGLE
----------------------------------------------------------------
vim.keymap.set("n", "<leader>up", function()
	vim.opt.paste = not vim.opt.paste:get()
	vim.notify("paste=" .. tostring(vim.opt.paste:get()))
end, { desc = "Toggle paste mode" })

----------------------------------------------------------------
-- TREESITTER: DISABLE INDENT MODULE (GUARD AGAINST ACCIDENTAL ENABLE)
----------------------------------------------------------------
pcall(function()
	require("nvim-treesitter.configs").setup({ indent = { enable = false } })
end)

----------------------------------------------------------------
-- HTML: FILETYPE-SPECIFIC INDENT TWEAKS
----------------------------------------------------------------
vim.g.html_indent_autotags = "html,body,head"
vim.g.html_indent_script1 = "inc"
vim.g.html_indent_style1 = "inc"

----------------------------------------------------------------
-- FORMAT-ON-SAVE TOGGLE
----------------------------------------------------------------
vim.g.disable_autoformat = false

----------------------------------------------------------------
-- ROOT / CWD HELPERS
----------------------------------------------------------------
local function project_root()
	local markers = {
		".git",
		"flake.nix",
		"package.json",
		"mix.exs",
		"Cargo.toml",
		"*.cabal",
		"stack.yaml",
	}

	local path = vim.api.nvim_buf_get_name(0)
	local start = path ~= "" and vim.fs.dirname(path) or vim.fn.getcwd()
	local found = vim.fs.find(markers, { upward = true, path = start })[1]

	if found then
		return vim.fs.dirname(found)
	end

	return vim.fn.getcwd()
end

_G.project_root = project_root

vim.keymap.set("n", "<leader>uc", function()
	local root = project_root()
	vim.cmd.lcd(root)
	vim.notify("cwd=" .. root)
end, { desc = "Set cwd to project root" })

vim.keymap.set("n", "<leader>uC", function()
	local cwd = vim.fn.expand("%:p:h")
	if cwd == "" then
		cwd = vim.fn.getcwd()
	end
	vim.cmd.lcd(cwd)
	vim.notify("cwd=" .. cwd)
end, { desc = "Set cwd to buffer dir" })

vim.keymap.set("n", "<leader>uf", function()
	vim.g.disable_autoformat = not vim.g.disable_autoformat
	vim.notify("format on save=" .. tostring(not vim.g.disable_autoformat))
end, { desc = "Toggle format on save" })

vim.keymap.set("n", "<leader>uF", function()
	local ok, conform = pcall(require, "conform")
	if ok then
		conform.format({ async = true, lsp_format = "never" })
		return
	end

	vim.lsp.buf.format({ async = true })
end, { desc = "Format buffer now" })
