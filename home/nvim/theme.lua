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

	vim.api.nvim_set_hl(0, "Visual", { bg = "#374145" })
	vim.api.nvim_set_hl(0, "Search", { fg = "#272e33", bg = "#dbbc7f" })
	vim.api.nvim_set_hl(0, "IncSearch", { fg = "#272e33", bg = "#e69875", bold = true })
	vim.api.nvim_set_hl(0, "CurSearch", { fg = "#272e33", bg = "#e69875", bold = true })
	vim.api.nvim_set_hl(0, "CursorLine", { bg = "#2f383e" })
	vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#d3c6aa", bold = true })
	vim.api.nvim_set_hl(0, "PmenuSel", { fg = "#d3c6aa", bg = "#374145", bold = true })
	vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#7a8478", bg = "NONE" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
end

vim.api.nvim_create_autocmd("ColorScheme", { callback = fix_snacks_links })
fix_snacks_links()
