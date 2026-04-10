----------------------------------------------------------------
-- CORE: PROJECT ROOT, FORMAT TOGGLES, EDITOR TWEAKS
-- This file remains because it holds runtime-dependent custom logic
-- that is not a clean fit for current nvf module options.
----------------------------------------------------------------

do
	vim.g.haskell_tools = {
		hls = {
			cmd = {
				"haskell-language-server-wrapper",
				"--lsp",
			},
		},
	}
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

do
	local search_group = vim.api.nvim_create_augroup("search_highlight_qol", { clear = true })

	local function clear_search_highlight()
		if vim.v.hlsearch == 1 then
			vim.schedule(function()
				pcall(vim.cmd, "nohlsearch")
			end)
		end
	end

	vim.api.nvim_create_autocmd("CursorMoved", {
		group = search_group,
		callback = clear_search_highlight,
	})

	vim.api.nvim_create_autocmd("InsertEnter", {
		group = search_group,
		callback = clear_search_highlight,
	})

	vim.keymap.set("n", "<Esc>", function()
		clear_search_highlight()
		return "<Esc>"
	end, { expr = true, desc = "Escape and clear search highlight" })
end

do
	local codex_terminal

	local function toggle_codex()
		local ok, terminal = pcall(require, "toggleterm.terminal")
		if not ok then
			vim.notify("toggleterm is not available", vim.log.levels.ERROR)
			return
		end

		if not codex_terminal then
			codex_terminal = terminal.Terminal:new({
				cmd = "codex",
				direction = "vertical",
				size = 80,
				hidden = true,
				close_on_exit = false,
				on_open = function()
					vim.cmd.startinsert()
				end,
				on_close = function()
					vim.cmd.stopinsert()
				end,
			})
		end

		codex_terminal:toggle()
	end

	_G.toggle_codex = toggle_codex
end
