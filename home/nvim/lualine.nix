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
