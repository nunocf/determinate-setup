# Generates Lua that resolves LSP server commands shell-first.
# Prefer executables inherited from the shell / flake dev environment;
# fall back to the Nix store path only when the shell does not provide them.
# Add entries here for any server whose binary might come from a project shell.
{pkgs}:
pkgs.writeText "nvf-lsp-path-first.lua" ''
  local function path_first_cmd(binary, fallback, extra)
  	local cmd = vim.fn.exepath(binary)

  	if cmd == nil or cmd == "" then
  		cmd = fallback
  	end

  	local argv = { cmd }
  	if extra then
  		vim.list_extend(argv, extra)
  	end
  	return argv
  end

  local lsp_fallbacks = {
  	["lua-language-server"] = {
  		binary = "lua-language-server",
  		fallback = "${pkgs.lua-language-server}/bin/lua-language-server",
  	},
  	["marksman"] = {
  		binary = "marksman",
  		fallback = "${pkgs.marksman}/bin/marksman",
  		extra = { "server" },
  	},
  	["nil"] = {
  		binary = "nil",
  		fallback = "${pkgs.nil}/bin/nil",
  	},
  }

  do
  	local config = vim.lsp.config
  	for server_name, spec in pairs(lsp_fallbacks) do
  		if config[server_name] then
  			config[server_name].cmd = path_first_cmd(spec.binary, spec.fallback, spec.extra)
  		end
  	end
  end
''
