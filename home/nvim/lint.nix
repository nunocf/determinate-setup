{ pkgs, lib, ... }:
{
  enable = true;
  lint_after_save = true;

  linters_by_ft = {
    nix = [ "statix" "deadnix" ];
    elixir = [ "credo" ];
    eelixir = [ "credo" ];
    heex = [ "credo" ];
    sh = [ "shellcheck" ];
    bash = [ "shellcheck" ];
    lua = [ "luacheck" ];
    javascript = [ "eslint_d" ];
    javascriptreact = [ "eslint_d" ];
    typescript = [ "eslint_d" ];
    typescriptreact = [ "eslint_d" ];
    css = [ "stylelint" ];
    scss = [ "stylelint" ];
    markdown = [ "markdownlint-cli2" ];
  };

  linters = {
    statix.cmd = lib.getExe pkgs.statix;
    deadnix.cmd = lib.getExe pkgs.deadnix;
    shellcheck.cmd = lib.getExe pkgs.shellcheck;
    luacheck.cmd = lib.getExe pkgs.luajitPackages.luacheck;
    markdownlint-cli2.cmd = "markdownlint-cli2";
    hlint.cmd = "hlint";

    credo = {
      cmd = "mix";
      args = [ "credo" "--format" "flycheck" ];
      stdin = false;
      append_fname = false;
      required_files = [ "mix.exs" ".credo.exs" ];
    };

    eslint_d = {
      cmd = "eslint_d";
      required_files = [
        "eslint.config.js"
        "eslint.config.mjs"
        "eslint.config.cjs"
        ".eslintrc"
        ".eslintrc.js"
        ".eslintrc.cjs"
        ".eslintrc.json"
        ".eslintrc.yaml"
        ".eslintrc.yml"
      ];
    };

    stylelint = {
      cmd = "stylelint";
      required_files = [
        "stylelint.config.js"
        "stylelint.config.cjs"
        "stylelint.config.mjs"
        ".stylelintrc"
        ".stylelintrc.js"
        ".stylelintrc.cjs"
        ".stylelintrc.json"
        ".stylelintrc.yaml"
        ".stylelintrc.yml"
        "package.json"
      ];
    };
  };
}
