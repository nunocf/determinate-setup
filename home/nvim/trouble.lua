----------------------------------------------------------------
-- DIAGNOSTICS / HLS READABILITY
----------------------------------------------------------------
vim.diagnostic.config({
	severity_sort = true,

	float = {
		border = "rounded",
		source = "if_many",
		focusable = false,
		style = "minimal",
		wrap = true,
		max_width = 100,
	},

	virtual_text = {
		spacing = 2,
		prefix = "●",
		wrap = true,
	},
})

vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { link = "ErrorMsg" })

----------------------------------------------------------------
-- FLOAT ON CURSOR HOLD (VERY NICE FOR HLS)
----------------------------------------------------------------
vim.o.updatetime = 400

vim.api.nvim_create_autocmd("CursorHold", {
	callback = function()
		vim.diagnostic.open_float(nil, {
			focus = false,
			scope = "cursor",
		})
	end,
})

----------------------------------------------------------------
-- SAFE CODE ACTION PICKER
----------------------------------------------------------------
vim.lsp.handlers["textDocument/codeAction"] = function(err, actions)
	if err or not actions or vim.tbl_isempty(actions) then
		return
	end

	local items = {}

	for _, action in ipairs(actions) do
		table.insert(items, { title = action.title, action = action })
	end

	vim.ui.select(items, {
		prompt = "Code actions",
		format_item = function(item)
			return item.title
		end,
	}, function(choice)
		if not choice then
			return
		end
		local action = choice.action

		if action.edit then
			vim.lsp.util.apply_workspace_edit(action.edit, "utf-8")
		end

		if action.command then
			vim.lsp.buf.execute_command(action.command)
		end
	end)
end

----------------------------------------------------------------
-- HASKELL TYPED HOLE HIGHLIGHT
----------------------------------------------------------------
vim.api.nvim_set_hl(0, "HaskellHole", { link = "DiagnosticError" })

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*.hs",
	callback = function()
		vim.fn.matchadd("HaskellHole", "_")
	end,
})

----------------------------------------------------------------
-- TARGET-AWARE SMART GHCID LAUNCHER
----------------------------------------------------------------
local ghcid_open = false

local function detect_cabal_target()
	local cabal_files = vim.fn.glob("*.cabal", false, true)
	if #cabal_files == 0 then
		return nil
	end

	local cabal = cabal_files[1]
	local lines = vim.fn.readfile(cabal)

	local preferred = { "library", "executable", "test-suite" }

	for _, want in ipairs(preferred) do
		for _, l in ipairs(lines) do
			local name = l:match("^%s*" .. want .. "%s+([%w%-%_]+)")
			if name then
				if want == "library" then
					return "lib:" .. name
				elseif want == "executable" then
					return "exe:" .. name
				elseif want == "test-suite" then
					return "test:" .. name
				end
			end
		end
	end

	return nil
end

local function smart_ghcid()
	if ghcid_open then
		vim.cmd("ToggleTermToggleAll")
		return
	end

	local cwd = vim.fn.getcwd()

	local function exists(file)
		return vim.fn.filereadable(cwd .. "/" .. file) == 1
	end

	local cmd

	if exists("stack.yaml") then
		cmd = 'ghcid -c "stack repl"'
	elseif #vim.fn.glob("*.cabal", false, true) > 0 then
		local target = detect_cabal_target()

		if target then
			cmd = 'ghcid -c "cabal repl ' .. target .. '"'
		else
			cmd = 'ghcid -c "cabal repl"'
		end
	else
		cmd = "ghcid"
	end

	ghcid_open = true
	vim.cmd("ToggleTerm direction=float size=20 cmd=" .. cmd)
end

vim.api.nvim_create_user_command("SmartGhcid", smart_ghcid, {})

vim.api.nvim_create_autocmd("TermClose", {
	callback = function()
		ghcid_open = false
	end,
})
