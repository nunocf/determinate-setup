----------------------------------------------------------------
-- FILETYPE-AWARE MAP HELPER
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

_G.ftmap = ftmap

----------------------------------------------------------------
-- FILETYPE-SPECIFIC MAPPINGS
----------------------------------------------------------------

-- Haskell
ftmap("haskell", "<leader>gh", "<cmd>SmartGhcid<cr>", "Haskell: ghcid")

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

-- Nix
ftmap("nix", "<leader>nn", "<cmd>!nix fmt<cr>", "Nix: format")

-- Markdown
ftmap("markdown", "<leader>mw", function()
	vim.opt.wrap = not vim.opt.wrap:get()
end, "Markdown: toggle wrap")

----------------------------------------------------------------
-- STATIC WHICH-KEY GROUPS
----------------------------------------------------------------

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
