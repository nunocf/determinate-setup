----------------------------------------------------------------
-- FILETYPE HELPERS AND LOCAL MAPPINGS
-- This file remains because it provides buffer-local, filetype-scoped
-- custom behavior that this nvf version does not express cleanly.
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
ftmap(
	"haskell",
	"<leader>rr",
	"<cmd>lua vim.lsp.buf.code_action({ context = { only = { 'refactor', 'quickfix' } } })<cr>",
	"Haskell: refactors"
)
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
	vim.keymap.set("n", "<leader>mw", function()
		vim.opt_local.wrap = not vim.opt_local.wrap:get()
	end, { desc = "Markdown: toggle wrap", silent = true, noremap = true, buffer = true })
end)
