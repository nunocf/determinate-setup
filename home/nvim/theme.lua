local function fix_snacks_links()
	-- Snacks notifier links
	local map = {
		Error = "DiagnosticSignError",
		Warn = "DiagnosticSignWarn",
		Info = "DiagnosticSignInfo",
		Hint = "DiagnosticSignHint",
	}

	for lvl, sign in pairs(map) do
		vim.api.nvim_set_hl(0, "SnacksNotifierBorder" .. lvl, { link = sign })
		vim.api.nvim_set_hl(0, "SnacksNotifierTitle" .. lvl, { link = sign })
		vim.api.nvim_set_hl(0, "SnacksNotifierFooter" .. lvl, { link = sign })
	end

	-- Snacks picker readability (Everforest-aligned)
	vim.api.nvim_set_hl(0, "SnacksPickerDir", { link = "Directory" })
	vim.api.nvim_set_hl(0, "SnacksPickerPath", { link = "Directory" })
	vim.api.nvim_set_hl(0, "SnacksPickerDim", { link = "Directory" })
end

vim.api.nvim_create_autocmd("ColorScheme", { callback = fix_snacks_links })
fix_snacks_links()
