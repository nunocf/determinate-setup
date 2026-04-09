----------------------------------------------------------------
-- LIGHTWEIGHT SESSION PERSISTENCE
----------------------------------------------------------------

local session_dir = vim.fn.stdpath("state") .. "/sessions"
vim.fn.mkdir(session_dir, "p")

local function is_real_buffer(bufnr)
	if not vim.api.nvim_buf_is_valid(bufnr) then
		return false
	end

	if not vim.bo[bufnr].buflisted then
		return false
	end

	if vim.bo[bufnr].buftype ~= "" then
		return false
	end

	local name = vim.api.nvim_buf_get_name(bufnr)
	return name ~= ""
end

local function has_real_buffers()
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if is_real_buffer(bufnr) then
			return true
		end
	end

	return false
end

local function session_name()
	local root = _G.project_root and _G.project_root() or vim.fn.getcwd()
	local escaped = root:gsub("/", "%%")
	return session_dir .. "/" .. escaped .. ".vim"
end

local function session_save()
	if not has_real_buffers() then
		return
	end

	local path = session_name()
	vim.cmd("silent! mksession! " .. vim.fn.fnameescape(path))
end

local function session_load()
	local path = session_name()
	if vim.fn.filereadable(path) == 0 then
		vim.notify("no session for project")
		return
	end

	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buftype ~= "terminal" then
			pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
		end
	end

	vim.cmd("silent! source " .. vim.fn.fnameescape(path))
	vim.cmd("silent! bufdo if &buftype !=# '' | silent! bwipeout | endif")
	vim.notify("session restored")
end

local function session_delete()
	local path = session_name()
	if vim.fn.filereadable(path) == 0 then
		vim.notify("no session to delete")
		return
	end

	vim.fn.delete(path)
	vim.notify("session deleted")
end

vim.opt.sessionoptions = {
	"buffers",
	"curdir",
	"folds",
	"globals",
	"help",
	"localoptions",
	"tabpages",
	"terminal",
	"winsize",
}

vim.api.nvim_create_user_command("SessionSave", session_save, {})
vim.api.nvim_create_user_command("SessionLoad", session_load, {})
vim.api.nvim_create_user_command("SessionDelete", session_delete, {})

vim.api.nvim_create_autocmd("VimLeavePre", {
	callback = function()
		if vim.v.this_session ~= "" then
			return
		end

		if vim.fn.argc() == 0 and not has_real_buffers() then
			return
		end

		session_save()
	end,
})
