_: {
  programs.kitty = {
    enable = true;
    darwinLaunchOptions = ["--start-as=maximized"];
    shellIntegration.enableZshIntegration = true;
    settings = {
      font_size = "17.0";
      font_family = "JetBrainsMono Nerd Font";
      disable_ligatures = "cursor";
      copy_on_select = "yes";
      confirm_os_window_close = 0;
      scrollback_lines = 10000;

      enabled_layouts = "tall:bias=30;full_size=1;mirrored=false";
      hide_window_decorations = "titlebar-only";
      window_padding_width = "8";
      placement_strategy = "center";
      cursor_shape = "beam";
      cursor_beam_thickness = "1.5";

      tab_title_template = "Tab {index}: {title}";
      active_tab_font_style = "bold";
      inactive_text_alpha = "0.9";
    };

    # themeFile = "Kanagawa";
    themeFile = "everforest_dark_medium";
    # themeFile = "rose-pine-moon";

    keybindings = {
      "ctrl+shift+h" = "previous_tab";
      "ctrl+shift+l" = "next_tab";
      "ctrl+shift+enter" = "new_window_with_cwd";
    };
  };
}
