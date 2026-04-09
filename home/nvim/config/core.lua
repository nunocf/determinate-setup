----------------------------------------------------------------
-- CORE: PROJECT ROOT, FORMAT TOGGLES, EDITOR TWEAKS
----------------------------------------------------------------

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

	vim.g.haskell_tools = ht
end

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

vim.api.nvim_create_autocmd("FileType", {
	pattern = "nix",
	callback = function()
		vim.bo.indentexpr = ""
		vim.b.did_indent = nil
		vim.cmd("silent! runtime! indent/nix.vim")
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		vim.opt_local.formatoptions:remove({ "c", "r", "o" })
		vim.opt_local.formatoptions:append({ "j" })
	end,
})

pcall(function()
	require("nvim-treesitter.configs").setup({ indent = { enable = false } })
end)

vim.g.html_indent_autotags = "html,body,head"
vim.g.html_indent_script1 = "inc"
vim.g.html_indent_style1 = "inc"

vim.g.disable_autoformat = false

local function project_root(bufnr)
	local markers = {
		".git",
		"flake.nix",
		"package.json",
		"tsconfig.json",
		"Gemfile",
		".ruby-version",
		"Cargo.toml",
		"*.cabal",
		"stack.yaml",
	}

	bufnr = bufnr or 0
	local path = vim.api.nvim_buf_get_name(bufnr)
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

vim.keymap.set("n", "<leader>up", function()
	vim.opt.paste = not vim.opt.paste:get()
	vim.notify("paste=" .. tostring(vim.opt.paste:get()))
end, { desc = "Toggle paste mode" })
