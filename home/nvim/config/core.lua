----------------------------------------------------------------
-- CORE: PROJECT ROOT, FORMAT TOGGLES, EDITOR TWEAKS
-- This file remains because it holds runtime-dependent custom logic
-- that is not a clean fit for current nvf module options.
----------------------------------------------------------------

do
	local ns = vim.api.nvim_create_namespace("nix_injected_lua_background")
	local hl_group = "NixInjectedLuaBackground"

	local function update_injected_background(bufnr)
		if vim.bo[bufnr].filetype ~= "nix" then
			return
		end

		local ok, parser = pcall(vim.treesitter.get_parser, bufnr, "nix")
		if not ok then
			return
		end

		local tree = parser:parse()[1]
		if not tree then
			return
		end

		local query = vim.treesitter.query.get("nix", "injections")
		if not query then
			return
		end

		vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

		for id, node in query:iter_captures(tree:root(), bufnr, 0, -1) do
			if query.captures[id] == "nix.lua.background" then
				local start_row, start_col, end_row, end_col = node:range()
				vim.api.nvim_buf_set_extmark(bufnr, ns, start_row, start_col, {
					end_row = end_row,
					end_col = end_col,
					hl_group = hl_group,
					hl_mode = "combine",
				})
			end
		end
	end

	local group = vim.api.nvim_create_augroup("nix_injected_lua_background", {
		clear = true,
	})

	vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged", "TextChangedI", "InsertLeave" }, {
		group = group,
		pattern = "*.nix",
		callback = function(args)
			update_injected_background(args.buf)
		end,
	})
end

do
	local function strip_undercurl(hl)
		hl.undercurl = nil
		hl.underline = nil
		if hl.cterm then
			hl.cterm.undercurl = nil
			hl.cterm.underline = nil
		end
		return hl
	end

	local function sync_which_key_icons()
		local mappings = {
			WhichKeyIcon = "@markup.link",
			WhichKeyIconAzure = "Function",
			WhichKeyIconBlue = "DiagnosticInfo",
			WhichKeyIconCyan = "DiagnosticHint",
			WhichKeyIconGreen = "DiagnosticOk",
			WhichKeyIconGrey = "Normal",
			WhichKeyIconOrange = "DiagnosticWarn",
			WhichKeyIconPurple = "Constant",
			WhichKeyIconRed = "DiagnosticError",
			WhichKeyIconYellow = "DiagnosticWarn",
		}

		for target, source in pairs(mappings) do
			local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = source, link = false })
			if ok and hl then
				vim.api.nvim_set_hl(0, target, strip_undercurl(hl))
			end
		end
	end

	vim.api.nvim_create_autocmd("ColorScheme", {
		callback = sync_which_key_icons,
	})
	sync_which_key_icons()
end

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

	if type(ht.tools) ~= "table" then
		ht.tools = {}
	end
	if type(ht.tools.hover) ~= "table" then
		ht.tools.hover = {}
	end
	ht.tools.hover.enable = nil

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

local function project_root(bufnr)
	local markers = {
		".git",
		"flake.nix",
		"mix.exs",
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

local function warn_missing_hls()
	if vim.bo.buftype ~= "" then
		return
	end

	local filetype = vim.bo.filetype
	if filetype ~= "haskell" and filetype ~= "lhaskell" then
		return
	end

	if vim.fn.exepath("haskell-language-server-wrapper") ~= "" then
		return
	end

	if vim.b._warned_missing_hls then
		return
	end

	vim.b._warned_missing_hls = true
	vim.schedule(function()
		vim.notify(
			"Haskell LSP is not available in this session. Start Neovim from the project dev shell so it can use the project HLS.",
			vim.log.levels.WARN
		)
	end)
end

vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, {
	pattern = { "*.hs", "*.lhs", "haskell", "lhaskell" },
	callback = warn_missing_hls,
})

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "FileType" }, {
	pattern = { "*.hs", "*.lhs", "haskell", "lhaskell" },
	callback = function(args)
		pcall(vim.treesitter.start, args.buf, "haskell")
	end,
})

-- Expert LSP (official Elixir language server, elixir-lang/expert)
-- Not in nixpkgs; add it to your project devShell flake.
do
	vim.lsp.config["expert"] = vim.tbl_deep_extend("force", vim.lsp.config["expert"] or {}, {
		cmd = { "expert", "--stdio" },
		filetypes = { "elixir", "eelixir", "heex", "eex" },
		root_markers = { "mix.exs" },
	})
	vim.lsp.enable("expert")
end

local function warn_missing_expert()
	if vim.bo.buftype ~= "" then
		return
	end

	local filetype = vim.bo.filetype
	if filetype ~= "elixir" and filetype ~= "eelixir" and filetype ~= "heex" and filetype ~= "eex" then
		return
	end

	if vim.fn.exepath("expert") ~= "" then
		return
	end

	if vim.b._warned_missing_expert then
		return
	end

	vim.b._warned_missing_expert = true
	vim.schedule(function()
		vim.notify(
			"Elixir LSP (expert) is not available in this session. Start Neovim from the project dev shell so it can use the project expert binary.",
			vim.log.levels.WARN
		)
	end)
end

vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, {
	pattern = { "*.ex", "*.exs", "*.heex", "*.eex", "elixir", "eelixir", "heex", "eex" },
	callback = warn_missing_expert,
})

local function refresh_haskell_diagnostics(bufnr)
	for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
		if client.supports_method and client:supports_method("workspace/diagnostic/refresh") then
			pcall(client.request, client, "workspace/diagnostic/refresh", {}, function() end, bufnr)
		end
	end
end

vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "InsertLeave", "BufWritePost" }, {
	pattern = { "*.hs", "*.lhs", "haskell", "lhaskell" },
	callback = function(args)
		refresh_haskell_diagnostics(args.buf)
	end,
})

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

local function format_buffer_now()
	local ok, conform = pcall(require, "conform")
	if ok then
		local opts = { async = true, lsp_format = "never" }
		if vim.bo.filetype == "nix" then
			opts.formatters = { "alejandra", "injected" }
		elseif vim.bo.filetype == "haskell" or vim.bo.filetype == "lhaskell" then
			opts.formatters = { "fourmolu", "injected" }
		end

		conform.format(opts)
		return
	end

	vim.lsp.buf.format({ async = true })
end

_G.format_buffer_now = format_buffer_now

vim.keymap.set("n", "<leader>uF", function()
	format_buffer_now()
end, { desc = "Format buffer now" })

vim.keymap.set("n", "<leader>up", function()
	vim.opt.paste = not vim.opt.paste:get()
	vim.notify("paste=" .. tostring(vim.opt.paste:get()))
end, { desc = "Toggle paste mode" })

do
	local search_group = vim.api.nvim_create_augroup("search_highlight_qol", { clear = true })

	local function clear_search_highlight()
		if vim.v.hlsearch == 1 then
			pcall(vim.cmd, "nohlsearch")
		end
	end

	vim.api.nvim_create_autocmd("InsertEnter", {
		group = search_group,
		callback = clear_search_highlight,
	})

	vim.keymap.set("n", "<CR>", function()
		if vim.v.hlsearch == 1 then
			pcall(vim.cmd, "nohlsearch")
			return ""
		end
		return "<CR>"
	end, { expr = true, desc = "Enter and clear search highlight" })

	vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result and recenter" })
	vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result and recenter" })

	vim.keymap.set("n", "<Esc>", function()
		clear_search_highlight()
		return "<Esc>"
	end, { expr = true, desc = "Escape and clear search highlight" })
end

do
	local function codecompanion_cmdline(lhs, rhs)
		vim.cmd.cnoreabbrev(("<expr> %s getcmdtype() == ':' && getcmdline() == '%s' && &filetype == 'codecompanion' ? '%s' : '%s'"):format(
			lhs,
			lhs,
			rhs,
			lhs
		))
	end

	for _, cmd in ipairs({ "q", "q!", "quit", "quit!", "wq", "wq!", "x", "x!" }) do
		codecompanion_cmdline(cmd, "CodeCompanionChat Toggle")
	end

	vim.api.nvim_create_autocmd("FileType", {
		pattern = "codecompanion",
		callback = function(args)
			local name = vim.api.nvim_buf_get_name(args.buf)
			if name:match("%[CodeCompanion%]") then
				pcall(vim.api.nvim_buf_set_name, args.buf, "Codex")
			end

			vim.wo.winbar = " Codex "
		end,
	})
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
			-- Work laptop: vim.g.ai_override_cmd is set at nix eval time to the
			-- exact claude store path, so we never fall through to codex.
			-- Personal machine: discover at runtime (PATH → nix profile → codex).
			local ai_cmd = vim.g.ai_override_cmd
			if not ai_cmd or ai_cmd == "" then
				ai_cmd = vim.fn.exepath("claude")
				if ai_cmd == "" then
					local nix_claude = vim.fn.expand("~/.nix-profile/bin/claude")
					if vim.fn.executable(nix_claude) == 1 then
						ai_cmd = nix_claude
					end
				end
				if ai_cmd == "" then
					ai_cmd = vim.fn.exepath("codex") ~= "" and "codex" or nil
				end
			end
			if not ai_cmd then
				vim.notify("No AI CLI found (claude or codex)", vim.log.levels.ERROR)
				return
			end
			codex_terminal = terminal.Terminal:new({
				cmd = ai_cmd,
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

-- Highlight the word under cursor differently from other CursorWord matches.
-- CursorWord (nvim-cursorline) highlights all instances with underline.
-- This overlays a higher-priority match at the cursor position only.
do
	local group = vim.api.nvim_create_augroup("cursorword_current", { clear = true })

	local function update_match()
		if vim.w.cursorword_current_id then
			pcall(vim.fn.matchdelete, vim.w.cursorword_current_id)
			vim.w.cursorword_current_id = nil
		end
		local ok, id = pcall(vim.fn.matchadd, "CursorWordCurrent", [[\k*\%#\k*]], 0)
		if ok and type(id) == "number" and id >= 0 then
			vim.w.cursorword_current_id = id
		end
	end

	local function clear_match()
		if vim.w.cursorword_current_id then
			pcall(vim.fn.matchdelete, vim.w.cursorword_current_id)
			vim.w.cursorword_current_id = nil
		end
	end

	local function set_hl()
		-- Other instances: plain underline (set by nvim-cursorline)
		-- Cursor instance: bold + subtle bg lift (everforest hard dark bg3)
		vim.api.nvim_set_hl(0, "CursorWordCurrent", { bold = true, bg = "#414b50" })
	end

	vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, { group = group, callback = update_match })
	vim.api.nvim_create_autocmd("WinLeave", { group = group, callback = clear_match })
	vim.api.nvim_create_autocmd("ColorScheme", { group = group, callback = set_hl })

	set_hl()
end
