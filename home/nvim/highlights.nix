# Highlight group overrides for the everforest hard dark theme.
# Colours reference: https://github.com/sainnhe/everforest
{
  # ── Snacks notifier ────────────────────────────────────────────────────
  SnacksNotifierBorderError = {link = "DiagnosticSignError";};
  SnacksNotifierTitleError = {link = "DiagnosticSignError";};
  SnacksNotifierFooterError = {link = "DiagnosticSignError";};
  SnacksNotifierBorderWarn = {link = "DiagnosticSignWarn";};
  SnacksNotifierTitleWarn = {link = "DiagnosticSignWarn";};
  SnacksNotifierFooterWarn = {link = "DiagnosticSignWarn";};
  SnacksNotifierBorderInfo = {link = "DiagnosticSignInfo";};
  SnacksNotifierTitleInfo = {link = "DiagnosticSignInfo";};
  SnacksNotifierFooterInfo = {link = "DiagnosticSignInfo";};
  SnacksNotifierBorderHint = {link = "DiagnosticSignHint";};
  SnacksNotifierTitleHint = {link = "DiagnosticSignHint";};
  SnacksNotifierFooterHint = {link = "DiagnosticSignHint";};
  SnacksPickerDir = {link = "Directory";};
  SnacksPickerPath = {link = "Directory";};
  SnacksPickerDim = {link = "Directory";};

  # ── Editor chrome ──────────────────────────────────────────────────────
  Visual = {bg = "#374145";};
  Search = {
    fg = "#272e33";
    bg = "#dbbc7f";
  };
  IncSearch = {
    fg = "#272e33";
    bg = "#e69875";
    bold = true;
  };
  CurSearch = {
    fg = "#272e33";
    bg = "#e69875";
    bold = true;
  };
  CursorLine = {bg = "#2f383e";};
  CursorLineNr = {
    fg = "#d3c6aa";
    bold = true;
  };
  PmenuSel = {
    fg = "#d3c6aa";
    bg = "#374145";
    bold = true;
  };

  # ── Floats / diagnostics ───────────────────────────────────────────────
  FloatBorder = {
    fg = "#a7c080";
    bg = "#2d353b";
  };
  NormalFloat = {
    fg = "#d3c6aa";
    bg = "#2d353b";
  };
  DiagnosticFloating = {
    fg = "#d3c6aa";
    bg = "#2d353b";
  };
  DiagnosticFloatingBorder = {
    fg = "#a7c080";
    bg = "#2d353b";
  };
  DiagnosticVirtualTextError = {link = "ErrorMsg";};
  DiagnosticInfo = {fg = "#7fbbb3";};

  # ── Language-specific ──────────────────────────────────────────────────
  HaskellHole = {link = "DiagnosticError";};
  NixInjectedLuaBackground = {bg = "#273036";};

  # ── Rainbow delimiters ─────────────────────────────────────────────────
  RainbowDelimiterRed = {fg = "#d699b6";};
  RainbowDelimiterYellow = {fg = "#dbbc7f";};
  RainbowDelimiterBlue = {fg = "#7fbbb3";};
  RainbowDelimiterOrange = {fg = "#e69875";};
  RainbowDelimiterGreen = {fg = "#a7c080";};
  RainbowDelimiterViolet = {fg = "#7a8478";};
  RainbowDelimiterCyan = {fg = "#83c092";};
}
