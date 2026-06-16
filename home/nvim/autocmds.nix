# Editor autocmds — spell, wrap, indent, and filetype tweaks.
# Language-specific LSP autocmds live in lsp/languages/<lang>/.
{lib}: let
  inherit (lib.generators) mkLuaInline;
in [
  # Disable spell for non-file buffers (terminals, quickfix, etc.)
  {
    event = ["FileType"];
    pattern = ["*"];
    callback = mkLuaInline ''
      function()
      	if vim.bo.buftype ~= "" then
      		return
      	end

      	vim.opt_local.spell = false
      end
    '';
  }

  # Enable spell for code filetypes (catches typos in comments/strings)
  {
    event = ["FileType"];
    pattern = ["bash" "css" "elixir" "haskell" "heex" "html" "javascript" "javascriptreact" "jsonc" "lua" "nix" "ruby" "scss" "sh" "tsx" "typescript" "typescriptreact" "yaml"];
    callback = mkLuaInline ''
      function()
      	if vim.bo.buftype ~= "" then
      		return
      	end

      	vim.opt_local.spell = true
      end
    '';
  }

  # Markdown: wrap, spell, soft-wrap at 100
  {
    event = ["BufReadPost" "BufNewFile"];
    pattern = ["*.md" "*.markdown" "*.mkd"];
    callback = mkLuaInline ''
      function()
      	if vim.bo.buftype ~= "" then
      		return
      	end

      	vim.opt_local.wrap = true
      	vim.opt_local.spell = true
      	vim.opt_local.linebreak = true
      	vim.opt_local.textwidth = 100
      end
    '';
  }

  # Git commits: hard-wrap at 72 (conventional commit style)
  {
    event = ["FileType"];
    pattern = ["gitcommit"];
    callback = mkLuaInline ''
      function()
      	if vim.bo.buftype ~= "" or vim.bo.filetype == "" then
      		return
      	end

      	vim.opt_local.wrap = true
      	vim.opt_local.textwidth = 72
      end
    '';
  }

  # TypeScript / JavaScript: 2-space indent + inlay hints
  # (mirrors the LSP settings in lsp/languages/typescript.nix)
  {
    event = ["FileType"];
    pattern = ["typescript" "typescriptreact" "javascript" "javascriptreact" "tsx"];
    callback = mkLuaInline ''
      function()
      	vim.opt_local.shiftwidth = 2
      	vim.opt_local.tabstop = 2
      	vim.opt_local.expandtab = true
      	vim.lsp.inlay_hint.enable(true, { bufnr = 0 })
      end
    '';
  }

  # Ruby: 2-space indent + allow ? and ! in identifiers
  # (mirrors the LSP settings in lsp/languages/ruby.nix)
  {
    event = ["FileType"];
    pattern = ["ruby"];
    callback = mkLuaInline ''
      function()
      	vim.opt_local.shiftwidth = 2
      	vim.opt_local.tabstop = 2
      	vim.opt_local.expandtab = true
      	vim.opt_local.iskeyword:append("?")
      	vim.opt_local.iskeyword:append("!")
      end
    '';
  }
]
