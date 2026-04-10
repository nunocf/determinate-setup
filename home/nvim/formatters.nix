{
  pkgs,
  lib,
  ...
}: {
  enable = true;
  setupOpts = {
    format_on_save = {
      timeout_ms = 2000;
      lsp_format = "never";
      quiet = false;
      format_after_save = false;
      condition = ''
        function(_, bufnr)
          return not vim.g.disable_autoformat and not vim.b[bufnr].disable_autoformat
        end
      '';
    };

    formatters_by_ft = {
      nix = ["alejandra"];
      haskell = ["fourmolu"];
      cabal = ["cabal_fmt"];
      lua = ["stylua"];
      ruby = ["rubocop"];
      sh = ["shfmt"];
      bash = ["shfmt"];
      javascript = ["prettierd"];
      javascriptreact = ["prettierd"];
      typescript = ["prettierd"];
      typescriptreact = ["prettierd"];
      tsx = ["prettierd"];
      html = ["prettierd"];
      css = ["prettierd"];
      scss = ["prettierd"];
      json = ["prettierd"];
      jsonc = ["prettierd"];
      yaml = ["prettierd"];
      markdown = ["prettierd"];
    };

    formatters = {
      alejandra.command = lib.getExe pkgs.alejandra;
      stylua.command = lib.getExe pkgs.stylua;
      shfmt.command = lib.getExe pkgs.shfmt;
      prettierd.command = "prettierd";
      fourmolu.command = "fourmolu";
      rubocop = {
        command = "rubocop";
        args = ["-A" "--stdin" "$FILENAME"];
        stdin = true;
      };
      cabal_fmt = {
        command = "cabal-fmt";
        args = ["--inplace" "$FILENAME"];
        stdin = false;
      };
    };
  };
}
