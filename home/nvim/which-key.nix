{
  enable = true;

  # Leader group labels shown in the which-key popup
  register = {
    "<leader>a" = "Apps/Agents";
    "<leader>f" = "Files";
    "<leader>g" = "Git/Build";
    "<leader>x" = "Diagnostics/Lists";
    "<leader>l" = "LSP";
    "<leader>c" = "Code/Change";
    "<leader>b" = "Buffers";
    "<leader>w" = "Windows";
    "<leader>s" = "Surface/UI";
    "<leader>u" = "Utilities/Toggles";
    "<leader>q" = "Quit/Session/Home";
    "<leader>t" = "Terminal";
    "<leader>m" = "Markdown";
    "<leader>n" = "Nix";
  };

  setupOpts = {
    preset = "modern";
    icons = {
      breadcrumb = "";
      separator = "";
      group = "+";
    };
    win.border = "rounded";
  };
}
