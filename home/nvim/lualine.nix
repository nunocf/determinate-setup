{
  enable = true;
  theme = "everforest";
  activeSection = {
    # Git branch
    b = [
      ''{ "branch", icon = ' ', colored = true, separator = {right = ''}, padding = { left = 1, right = 1 } } ''
    ];

    # Diff
    c = [
      ''
        {
              "diff",
              symbols = { added = " ", modified = " ", removed = " " },
              diff_color = { added = "DiffAdd", modified = "DiffChange", removed = "DiffDelete" },
              separator = { right = '' },
              padding = { left = 1, right = 1 }
            }''
    ];
    x = [
      ''
        { -- LSP server name (clean + rename haskell-tools.nvim -> hls)
          function()
            local buf_ft = vim.bo.filetype
            local excluded_buf_ft = {
              toggleterm = true,
              NvimTree = true,
              ["neo-tree"] = true,
              TelescopePrompt = true,
            }
            if excluded_buf_ft[buf_ft] then
              return ""
            end

            local bufnr = vim.api.nvim_get_current_buf()
            local clients = vim.lsp.get_clients({ bufnr = bufnr })

            -- If nothing is attached yet, be quiet (or show "LSP…" if you prefer)
            if not clients or vim.tbl_isempty(clients) then
              return ""
              -- return "LSP…"
            end

            local seen = {}
            local active_clients = {}

            for _, client in ipairs(clients) do
              local name = client.name or ""

              -- Rename haskell-tools wrapper to a friendlier label
              if name == "haskell-tools.nvim" then
                name = "hls"
              end

              -- Optional: hide noisy helper clients if you ever add them
              -- if name == "null-ls" then goto continue end

              if name ~= "" and not seen[name] then
                seen[name] = true
                table.insert(active_clients, name)
              end

              -- ::continue::
            end

            if #active_clients == 0 then
              return ""
              -- return "LSP…"
            end

            return table.concat(active_clients, ", ")
          end,
          icon = ' ',
          separator = { left = '' },
        }
      ''
      ''
        { "diagnostics",
          sources = { 'nvim_lsp', 'nvim_diagnostic', 'vim_lsp', 'coc' },
          symbols = { error = '󰅙 ', warn = ' ', info = ' ', hint = '󰌵 ' },
          colored = true,
          update_in_insert = false,
          always_visible = false,
          diagnostics_color = {
            color_error = { fg = 'red' },
            color_warn  = { fg = 'yellow' },
            color_info  = { fg = 'cyan' },
          },
        }
      ''
    ];

    # Search + Filetype + encoding
    y = [
      ''
        {
              "searchcount", maxcount = 999, timeout = 120,
              icons_enabled = true, icon = "",
              padding = { left = 1, right = 1 }
            }''
      ''
        {
              "encoding",
              icons_enabled = true,
              padding = { left = 1, right = 1 }
            }
      ''
      ''
        {
              "filetype",
              icons_enabled = true,
              colored = true,
              padding = { left = 1, right = 1 }
            }
      ''
    ];
    z = [
      ''{ "", draw_empty = true, separator = { left = '', right = '' } } ''
      ''{ "progress", separator = {left = ''} } ''
      ''{"location"} ''
    ];
  };
}
