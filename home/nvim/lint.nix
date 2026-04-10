{
  pkgs,
  lib,
  ...
}: let
  optionalLinter = condition: name: lib.optional condition name;
  shellFirstCmd = package: binary: ''
    sh -c 'if command -v ${binary} >/dev/null 2>&1; then exec ${binary} "$@"; else exec ${lib.getExe' package binary} "$@"; fi' sh
  '';
  statixEnabled = pkgs ? statix;
  deadnixEnabled = pkgs ? deadnix;
  shellcheckEnabled = pkgs ? shellcheck;
  luacheckEnabled = pkgs.luajitPackages ? luacheck;
  rubyEnabled = pkgs ? ruby;
  markdownlintEnabled = pkgs.nodePackages ? markdownlint-cli2;
  markdownlintCmd = shellFirstCmd pkgs.nodePackages.markdownlint-cli2 "markdownlint-cli2";
in {
  enable = true;
  lint_after_save = true;

  linters_by_ft = {
    nix = optionalLinter statixEnabled "statix" ++ optionalLinter deadnixEnabled "deadnix";
    sh = optionalLinter shellcheckEnabled "shellcheck";
    bash = optionalLinter shellcheckEnabled "shellcheck";
    lua = optionalLinter luacheckEnabled "luacheck";
    ruby = optionalLinter rubyEnabled "ruby";
    javascript = ["eslint_d"];
    javascriptreact = ["eslint_d"];
    typescript = ["eslint_d"];
    typescriptreact = ["eslint_d"];
    css = ["stylelint"];
    scss = ["stylelint"];
    markdown = optionalLinter markdownlintEnabled "markdownlint-cli2";
  };

  linters = {
    statix.cmd = "sh";
    statix.args = ["-c" (shellFirstCmd pkgs.statix "statix") "sh"];
    deadnix.cmd = "sh";
    deadnix.args = ["-c" (shellFirstCmd pkgs.deadnix "deadnix") "sh"];
    shellcheck.cmd = "sh";
    shellcheck.args = ["-c" (shellFirstCmd pkgs.shellcheck "shellcheck") "sh"];
    luacheck.cmd = "sh";
    luacheck.args = ["-c" (shellFirstCmd pkgs.luajitPackages.luacheck "luacheck") "sh"];
    markdownlint-cli2.cmd = markdownlintCmd;
    hlint.cmd = "sh";
    hlint.args = ["-c" (shellFirstCmd pkgs.hlint "hlint") "sh"];

    ruby = {
      cmd = "ruby";
      args = ["-wc" "$FILENAME"];
      stdin = false;
      append_fname = false;
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
