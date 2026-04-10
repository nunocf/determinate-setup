{
  pkgs,
  lib,
  ...
}: let
  optionalFormatter = condition: name: lib.optional condition name;
  shellFirstCommand = binary: fallback: ''
    if command -v ${binary} >/dev/null 2>&1; then
      exec ${binary} "$@"
    else
      exec ${fallback} "$@"
    fi
  '';
  alejandraEnabled = pkgs ? alejandra;
  fourmoluEnabled = pkgs ? fourmolu;
  cabalFmtEnabled = true;
  styluaEnabled = pkgs ? stylua;
  rubocopEnabled = pkgs ? rubocop;
  shfmtEnabled = pkgs ? shfmt;
  prettierdEnabled = pkgs ? prettierd;
in {
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
      nix = optionalFormatter alejandraEnabled "alejandra";
      haskell = optionalFormatter fourmoluEnabled "fourmolu";
      cabal = optionalFormatter cabalFmtEnabled "cabal_fmt";
      lua = optionalFormatter styluaEnabled "stylua";
      ruby = optionalFormatter rubocopEnabled "rubocop";
      sh = optionalFormatter shfmtEnabled "shfmt";
      bash = optionalFormatter shfmtEnabled "shfmt";
      javascript = optionalFormatter prettierdEnabled "prettierd";
      javascriptreact = optionalFormatter prettierdEnabled "prettierd";
      typescript = optionalFormatter prettierdEnabled "prettierd";
      typescriptreact = optionalFormatter prettierdEnabled "prettierd";
      tsx = optionalFormatter prettierdEnabled "prettierd";
      html = optionalFormatter prettierdEnabled "prettierd";
      css = optionalFormatter prettierdEnabled "prettierd";
      scss = optionalFormatter prettierdEnabled "prettierd";
      json = optionalFormatter prettierdEnabled "prettierd";
      jsonc = optionalFormatter prettierdEnabled "prettierd";
      yaml = optionalFormatter prettierdEnabled "prettierd";
      markdown = optionalFormatter prettierdEnabled "prettierd";
    };

    formatters = {
      alejandra = {
        command = "sh";
        args = [
          "-c"
          (shellFirstCommand "alejandra" (lib.getExe pkgs.alejandra))
          "sh"
          "--"
        ];
        stdin = true;
      };
      stylua = {
        command = "sh";
        args = [
          "-c"
          (shellFirstCommand "stylua" (lib.getExe pkgs.stylua))
          "sh"
          "--stdin-filepath"
          "$FILENAME"
          "-"
        ];
        stdin = true;
      };
      shfmt = {
        command = "sh";
        args = ["-c" (shellFirstCommand "shfmt" (lib.getExe pkgs.shfmt)) "sh"];
        stdin = true;
      };
      prettierd = {
        command = "sh";
        args = [
          "-c"
          (shellFirstCommand "prettierd" (lib.getExe pkgs.prettierd))
          "sh"
          "$FILENAME"
        ];
        stdin = true;
      };
      fourmolu = {
        command = "sh";
        args = [
          "-c"
          ''
            if command -v fourmolu >/dev/null 2>&1; then
              exec fourmolu --stdin-input-file "$FILENAME"
            else
              exec ${lib.getExe pkgs.fourmolu} --stdin-input-file "$FILENAME"
            fi
          ''
          "sh"
          "--"
        ];
        cwd = null;
        stdin = true;
      };
      rubocop = {
        command = "sh";
        args = [
          "-c"
          ''
            if command -v rubocop >/dev/null 2>&1; then
              exec rubocop -A --stdin "$1"
            else
              exec ${lib.getExe pkgs.rubocop} -A --stdin "$1"
            fi
          ''
          "sh"
          "$FILENAME"
        ];
        stdin = true;
      };
      cabal_fmt = {
        command = "sh";
        args = [
          "-c"
          ''
            exec cabal-fmt --inplace "$FILENAME"
          ''
          "sh"
        ];
        cwd = null;
        stdin = false;
      };
    };
  };
}
