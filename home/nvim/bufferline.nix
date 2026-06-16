{lib}: let
  inherit (lib.generators) mkLuaInline;
in {
  enable = true;
  setupOpts.options = {
    mode = "buffers";
    numbers = "none";
    close_command = "bdelete! %d";
    middle_mouse_command = "bdelete! %d";
    left_mouse_command = "buffer %d";
    right_mouse_command = "bdelete! %d";
    indicator = {
      style = "icon";
      icon = "▎";
    };
    buffer_close_icon = "󰅖";
    close_icon = "󰅖";
    modified_icon = "●";
    left_trunc_marker = "";
    max_name_length = 22;
    max_prefix_length = 15;
    tab_size = 18;
    themable = true;
    diagnostics = "nvim_lsp";
    diagnostics_update_in_insert = false;
    diagnostics_indicator = mkLuaInline ''
      function(count, level, diagnostics_dict, context)
      	return "(" .. count .. ")"
      end
    '';
    color_icons = true;
    show_buffer_icons = true;
    show_buffer_close_icons = true;
    show_close_icon = true;
    show_tab_indicators = true;
    persist_buffer_sort = true;
    always_show_bufferline = true;
    enforce_regular_tabs = false;
    sort_by = "directory";
    hover.enabled = true;
    truncate_names = true;
  };
}
