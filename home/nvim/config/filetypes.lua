----------------------------------------------------------------
-- FILETYPE HELPERS AND LOCAL MAPPINGS
----------------------------------------------------------------

local function ftmap(ft, lhs, rhs, desc)
	vim.api.nvim_create_autocmd("FileType", {
		pattern = ft,
		callback = function()
			vim.keymap.set("n", lhs, rhs, {
				desc = desc,
				silent = true,
				noremap = true,
				buffer = true,
			})
		end,
	})
end

local function ftopt(ft, callback)
	vim.api.nvim_create_autocmd("FileType", {
		pattern = ft,
		callback = callback,
	})
end

ftmap("haskell", "<leader>gh", "<cmd>SmartGhcid<cr>", "Haskell: ghcid")
ftmap("haskell", "<leader>rr", "<cmd>lua vim.lsp.buf.code_action({ context = { only = { 'refactor', 'quickfix' } } })<cr>", "Haskell: refactors")
ftmap("haskell", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", "Haskell: rename")

ftmap("haskell", "<leader>uh", function()
	local diags = vim.diagnostic.get(0)
	local cur = vim.api.nvim_win_get_cursor(0)[1] - 1
	for _, d in ipairs(diags) do
		if d.message:match("hole") and d.lnum > cur then
			vim.api.nvim_win_set_cursor(0, { d.lnum + 1, d.col or 0 })
			vim.diagnostic.open_float(nil, { focus = false })
			return
		end
	end
end, "Haskell: next hole")

ftmap("nix", "<leader>nn", "<cmd>!nix fmt<cr>", "Nix: format")
ftmap("ruby", "<leader>rr", "<cmd>lua vim.lsp.buf.rename()<cr>", "Ruby: rename")
ftmap("ruby", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", "Ruby: code action")

ftopt("markdown", function()
	vim.opt_local.wrap = true
	vim.opt_local.spell = true
	vim.opt_local.linebreak = true
	vim.opt_local.textwidth = 100
	vim.keymap.set("n", "<leader>mw", function()
		vim.opt_local.wrap = not vim.opt_local.wrap:get()
	end, { desc = "Markdown: toggle wrap", silent = true, noremap = true, buffer = true })
end)

ftopt("gitcommit", function()
	vim.opt_local.spell = true
	vim.opt_local.wrap = true
	vim.opt_local.textwidth = 72
end)

ftopt({ "typescript", "typescriptreact", "javascript", "javascriptreact", "tsx" }, function()
	vim.opt_local.shiftwidth = 2
	vim.opt_local.tabstop = 2
	vim.opt_local.expandtab = true
	vim.lsp.inlay_hint.enable(true, { bufnr = 0 })
end)

ftopt("ruby", function()
	vim.opt_local.shiftwidth = 2
	vim.opt_local.tabstop = 2
	vim.opt_local.expandtab = true
	vim.opt_local.iskeyword:append("?")
	vim.opt_local.iskeyword:append("!")
end)

local function wk_add_groups(buf)
	local ok, wk = pcall(require, "which-key")
	if not ok then
		return
	end

	wk.add({
		{ "<leader>f", group = "Files" },
		{ "<leader>g", group = "Git/Build" },
		{ "<leader>x", group = "Diagnostics" },
		{ "<leader>l", group = "LSP" },
		{ "<leader>c", group = "Code" },
		{ "<leader>b", group = "Buffers" },
		{ "<leader>w", group = "Windows" },
		{ "<leader>s", group = "UI/Search" },
		{ "<leader>u", group = "Toggles/Utils" },
		{ "<leader>q", group = "Quit" },
		{ "<leader>t", group = "Terminal" },
		{ "<leader>m", group = "Markdown" },
		{ "<leader>n", group = "Nix" },
	}, { buffer = buf })
end

wk_add_groups(nil)

vim.api.nvim_create_autocmd("FileType", {
	callback = function(ev)
		wk_add_groups(ev.buf)
	end,
})
