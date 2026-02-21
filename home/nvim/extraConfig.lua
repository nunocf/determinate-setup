vim.cmd("filetype plugin indent on")

-- Force Nix to use vim-nix indent, not treesitter indentexpr
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
-- Prevent auto-continuing comments on newline (very LazyVim-feeling)
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		vim.opt_local.formatoptions:remove({ "c", "r", "o" }) -- no auto comment on Enter/o/O
		vim.opt_local.formatoptions:append({ "j" }) -- remove comment leader when possible
	end,
})

-- Paste without wrecking indentation (toggle)
-- LazyVim uses a paste toggle mapping; here’s a clean one:
vim.keymap.set("n", "<leader>up", function()
	vim.opt.paste = not vim.opt.paste:get()
	vim.notify("paste=" .. tostring(vim.opt.paste:get()))
end, { desc = "Toggle paste mode" })

-- Don’t use Treesitter indentation (it’s still flaky for some languages)
-- NVF doesn’t enable it by default, but this guards against accidental enable.
pcall(function()
	require("nvim-treesitter.configs").setup({ indent = { enable = false } })
end)

-- Filetype-specific indent tweaks for webdev (reduces annoying extra indents)
vim.g.html_indent_autotags = "html,body,head"
vim.g.html_indent_script1 = "inc"
vim.g.html_indent_style1 = "inc"
