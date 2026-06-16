local ok, dropbar = pcall(require, "dropbar")
if not ok then
	return
end

local sources = require("dropbar.sources")

dropbar.setup({
	bar = {
		sources = function(buf, _)
			if vim.bo[buf].buftype == "terminal" then
				return { sources.terminal }
			end

			return { sources.path }
		end,
	},
})
