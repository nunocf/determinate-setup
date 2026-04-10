----------------------------------------------------------------
-- DIAGNOSTICS, THEME LINKS, AND HASKELL UTILITIES
-- This file remains because it contains interactive diagnostic and
-- terminal workflow logic that depends on runtime/editor state.
----------------------------------------------------------------

vim.api.nvim_create_autocmd("CursorHold", {
	callback = function()
		if not vim.g.diagnostic_hover_enabled then
			return
		end

		if vim.api.nvim_get_mode().mode ~= "n" then
			return
		end

		local float_win = vim.b.diagnostic_hover_win
		if float_win and vim.api.nvim_win_is_valid(float_win) then
			return
		end

		local cursor_diags = vim.diagnostic.get(0, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })
		if vim.tbl_isempty(cursor_diags) then
			return
		end

		local _, winid = vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
		vim.b.diagnostic_hover_win = winid
	end,
})

vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter", "BufLeave" }, {
	callback = function()
		local float_win = vim.b.diagnostic_hover_win
		if float_win and vim.api.nvim_win_is_valid(float_win) then
			vim.api.nvim_win_close(float_win, true)
		end
		vim.b.diagnostic_hover_win = nil
	end,
})

vim.keymap.set("n", "<leader>ux", function()
	vim.g.diagnostic_hover_enabled = not vim.g.diagnostic_hover_enabled
	if not vim.g.diagnostic_hover_enabled then
		local float_win = vim.b.diagnostic_hover_win
		if float_win and vim.api.nvim_win_is_valid(float_win) then
			vim.api.nvim_win_close(float_win, true)
		end
		vim.b.diagnostic_hover_win = nil
	end
	vim.notify("diagnostic hover=" .. tostring(vim.g.diagnostic_hover_enabled))
end, { desc = "Toggle diagnostic hover" })

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*.hs",
	callback = function()
		vim.fn.matchadd("HaskellHole", "_")
	end,
})

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
		for _, line in ipairs(lines) do
			local name = line:match("^%s*" .. want .. "%s+([%w%-%_]+)")
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

	local cwd = _G.project_root and _G.project_root() or vim.fn.getcwd()
	local function exists(file)
		return vim.fn.filereadable(cwd .. "/" .. file) == 1
	end

	local cmd
	if exists("stack.yaml") then
		cmd = 'ghcid -c "stack repl"'
	elseif #vim.fn.glob(cwd .. "/*.cabal", false, true) > 0 then
		local prev = vim.fn.getcwd()
		vim.cmd.lcd(cwd)
		local target = detect_cabal_target()
		vim.cmd.lcd(prev)

		if target then
			cmd = 'ghcid -c "cabal repl ' .. target .. '"'
		else
			cmd = 'ghcid -c "cabal repl"'
		end
	else
		cmd = "ghcid"
	end

	ghcid_open = true
	vim.cmd("ToggleTerm direction=float dir=" .. vim.fn.fnameescape(cwd) .. " size=20 cmd=" .. vim.fn.shellescape(cmd))
end

vim.api.nvim_create_user_command("SmartGhcid", smart_ghcid, {})

vim.api.nvim_create_autocmd("TermClose", {
	callback = function()
		ghcid_open = false
	end,
})
