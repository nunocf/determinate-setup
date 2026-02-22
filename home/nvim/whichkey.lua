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
-- DYNAMIC LEADER DASHBOARD (NO Snacks.picker UI)
----------------------------------------------------------------
local function leader_dashboard()
	local items = {} -- list of { label = "...", run = function() ... end }

	local function cmd_exists(name)
		return vim.fn.exists(":" .. name) == 2
	end

	local function add(label, fn)
		table.insert(items, {
			label = label,
			run = function()
				local ok, err = pcall(fn)
				if not ok then
					vim.notify(("Dashboard action failed: %s\n%s"):format(label, err), vim.log.levels.ERROR)
				end
			end,
		})
	end

	-- Try to use Snacks' existing pickers (not Snacks UI)
	local ok_snacks, Snacks = pcall(require, "snacks")

	-- Always available
	if ok_snacks and Snacks and Snacks.picker then
		add("Find file", function()
			Snacks.picker.files()
		end)
		add("Live grep", function()
			Snacks.picker.grep()
		end)
		add("Buffers", function()
			Snacks.picker.buffers()
		end)
	else
		add("Find file (fallback: netrw)", function()
			vim.cmd("Explore")
		end)
	end

	-- LSP (only if attached)
	if next(vim.lsp.get_clients({ bufnr = 0 })) ~= nil then
		add("Go to definition", vim.lsp.buf.definition)
		add("References", vim.lsp.buf.references)
		add("Rename symbol", vim.lsp.buf.rename)
		add("Code action", vim.lsp.buf.code_action)
	end

	-- Diagnostics
	if #vim.diagnostic.get(0) > 0 then
		add("Next diagnostic", function()
			vim.diagnostic.goto_next()
			vim.diagnostic.open_float(nil, { focus = false })
		end)

		if cmd_exists("Trouble") then
			add("Trouble (buffer diagnostics)", function()
				vim.cmd("Trouble diagnostics toggle filter.buf=0")
			end)
		end
	end

	-- Git
	if vim.fn.finddir(".git", ".;") ~= "" and cmd_exists("LazyGit") then
		add("LazyGit", function()
			vim.cmd("LazyGit")
		end)
	end

	-- Haskell
	if vim.bo.filetype == "haskell" then
		if cmd_exists("SmartGhcid") and vim.fn.executable("ghcid") == 1 then
			add("Run ghcid", function()
				vim.cmd("SmartGhcid")
			end)
		end

		add("Next typed hole", function()
			local diags = vim.diagnostic.get(0)
			local cur = vim.api.nvim_win_get_cursor(0)[1] - 1
			for _, d in ipairs(diags) do
				if d.message and d.message:match("hole") and d.lnum > cur then
					vim.api.nvim_win_set_cursor(0, { d.lnum + 1, d.col or 0 })
					vim.diagnostic.open_float(nil, { focus = false })
					return
				end
			end
			vim.notify("No more typed holes", vim.log.levels.INFO)
		end)
	end

	if #items == 0 then
		vim.notify("Leader Dashboard: no actions available", vim.log.levels.WARN)
		return
	end

	-- Native UI selector (stable)
	vim.ui.select(items, {
		prompt = "Leader Dashboard",
		format_item = function(item)
			return item.label
		end,
	}, function(choice)
		if choice then
			choice.run()
		end
	end)
end

vim.api.nvim_create_user_command("LeaderDashboard", leader_dashboard, {})
----------------------------------------------------------------
-- WHICH-KEY AUTO GROUP GENERATOR (GLOBAL + BUFFER)
----------------------------------------------------------------
local function wk_add_groups(buf)
	local ok, wk = pcall(require, "which-key")
	if not ok then
		return
	end

	local maps = buf and vim.api.nvim_buf_get_keymap(buf, "n") or vim.api.nvim_get_keymap("n")

	local names = {
		["<leader>f"] = "󰍉 Files",
		["<leader>g"] = "󰊢 Git/Build",
		["<leader>x"] = "󰒡 Diagnostics",
		["<leader>l"] = "󰒋 LSP",
		["<leader>c"] = "󰅩 Code",
		["<leader>b"] = "󰓩 Buffers",
		["<leader>w"] = "󰖲 Windows",
		["<leader>s"] = "󰙅 UI",
		["<leader>u"] = "󰔱 Utilities",
		["<leader>q"] = "󰩈 Quit",
	}

	local seen = {}
	local spec = {}

	for _, m in ipairs(maps) do
		if m.lhs:match("^<leader>") then
			local prefix = m.lhs:match("^(<leader>.).+")
			if prefix and not seen[prefix] then
				seen[prefix] = true
				table.insert(spec, {
					prefix:sub(9), -- strip "<leader>"
					group = names[prefix] or "Group",
				})
			end
		end
	end

	wk.add(spec, { prefix = "<leader>", buffer = buf })
end

vim.schedule(function()
	wk_add_groups(nil)
end)

vim.api.nvim_create_autocmd("FileType", {
	callback = function(ev)
		vim.defer_fn(function()
			wk_add_groups(ev.buf)
		end, 50)
	end,
})
