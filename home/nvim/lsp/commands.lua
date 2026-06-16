-- Aliases for native LSP commands (replaces nvim-lspconfig LspInfo/LspLog/etc.)
do
	vim.api.nvim_create_user_command("LspInfo", function()
		local clients = vim.lsp.get_clients({ bufnr = 0 })
		if #clients == 0 then
			vim.notify("No LSP clients attached to this buffer", vim.log.levels.INFO)
			return
		end
		local lines = { "LSP clients attached to buffer " .. vim.api.nvim_get_current_buf() .. ":", "" }
		for _, client in ipairs(clients) do
			table.insert(lines, ("  • %s  (id=%d)"):format(client.name, client.id))
			local root = client.root_dir or client.config and client.config.root_dir
			if root then
				table.insert(lines, ("      root: %s"):format(root))
			end
			local cap_count = vim.tbl_count(client.server_capabilities or {})
			table.insert(lines, ("      capabilities: %d"):format(cap_count))
		end
		vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO, { title = "LspInfo" })
	end, { desc = "Show LSP clients attached to current buffer" })

	vim.api.nvim_create_user_command("LspLog", function()
		vim.cmd.edit(vim.lsp.get_log_path())
	end, { desc = "Open LSP log file" })

	vim.api.nvim_create_user_command("LspRestart", function(opts)
		local filter = opts.args ~= "" and { name = opts.args, bufnr = 0 } or { bufnr = 0 }
		local clients = vim.lsp.get_clients(filter)
		if #clients == 0 then
			vim.notify("No matching LSP clients to restart", vim.log.levels.WARN)
			return
		end
		for _, client in ipairs(clients) do
			local name = client.name
			local bufs = vim.lsp.get_buffers_by_client_id(client.id)
			client:stop()
			vim.defer_fn(function()
				for _, bufnr in ipairs(bufs) do
					if vim.api.nvim_buf_is_valid(bufnr) then
						vim.lsp.start(client.config, { bufnr = bufnr })
					end
				end
				vim.notify("Restarted " .. name, vim.log.levels.INFO)
			end, 500)
		end
	end, { nargs = "?", desc = "Restart LSP clients (optional: server name)" })

	vim.api.nvim_create_user_command("LspStop", function(opts)
		local filter = opts.args ~= "" and { name = opts.args, bufnr = 0 } or { bufnr = 0 }
		for _, client in ipairs(vim.lsp.get_clients(filter)) do
			client:stop()
			vim.notify("Stopped " .. client.name, vim.log.levels.INFO)
		end
	end, { nargs = "?", desc = "Stop LSP clients (optional: server name)" })
end
