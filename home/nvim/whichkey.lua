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
-- DYNAMIC LEADER DASHBOARD
----------------------------------------------------------------
local function leader_dashboard()
	local actions = {}

	--------------------------------------------------------------
	-- Always available (Snacks pickers)
	--------------------------------------------------------------
	local ok_snacks, Snacks = pcall(require, "snacks")

	if ok_snacks then
		table.insert(actions, {
			"Find file",
			function()
				Snacks.picker.files()
			end,
		})
		table.insert(actions, {
			"Live grep",
			function()
				Snacks.picker.grep()
			end,
		})
		table.insert(actions, {
			"Buffers",
			function()
				Snacks.picker.buffers()
			end,
		})
	end

	--------------------------------------------------------------
	-- LSP actions
	--------------------------------------------------------------
	if next(vim.lsp.get_clients({ bufnr = 0 })) ~= nil then
		table.insert(actions, { "Go to definition", vim.lsp.buf.definition })
		table.insert(actions, { "References", vim.lsp.buf.references })
		table.insert(actions, { "Rename symbol", vim.lsp.buf.rename })
		table.insert(actions, { "Code action", vim.lsp.buf.code_action })
	end

	--------------------------------------------------------------
	-- Diagnostics
	--------------------------------------------------------------
	if #vim.diagnostic.get(0) > 0 then
		table.insert(actions, {
			"Next error",
			function()
				vim.diagnostic.goto_next()
				vim.diagnostic.open_float(nil, { focus = false })
			end,
		})

		table.insert(actions, {
			"Open Trouble",
			function()
				vim.cmd("Trouble diagnostics toggle filter.buf=0")
			end,
		})
	end

	--------------------------------------------------------------
	-- Git detection (works from subfolders)
	--------------------------------------------------------------
	if vim.fn.finddir(".git", ".;") ~= "" then
		table.insert(actions, {
			"LazyGit",
			function()
				vim.cmd("LazyGit")
			end,
		})
	end

	--------------------------------------------------------------
	-- Haskell tools
	--------------------------------------------------------------
	if vim.bo.filetype == "haskell" then
		if vim.fn.executable("ghcid") == 1 then
			table.insert(actions, {
				"Run ghcid",
				function()
					vim.cmd("SmartGhcid")
				end,
			})
		end

		table.insert(actions, {
			"Next typed hole",
			function()
				local diags = vim.diagnostic.get(0)
				local cur = vim.api.nvim_win_get_cursor(0)[1] - 1
				for _, d in ipairs(diags) do
					if d.message:match("hole") and d.lnum > cur then
						vim.api.nvim_win_set_cursor(0, { d.lnum + 1, d.col or 0 })
						vim.diagnostic.open_float(nil, { focus = false })
						return
					end
				end
			end,
		})
	end

	--------------------------------------------------------------
	-- SHOW MENU (Snacks picker OR fallback)
	--------------------------------------------------------------
	if ok_snacks then
		Snacks.picker({
			items = actions,
			format = function(item)
				return item[1]
			end,
			confirm = function(item)
				item[2]()
			end,
			title = "Leader Dashboard",
		})
	else
		vim.ui.select(actions, {
			prompt = "Leader Dashboard",
			format_item = function(item)
				return item[1]
			end,
		}, function(choice)
			if choice then
				choice[2]()
			end
		end)
	end
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
