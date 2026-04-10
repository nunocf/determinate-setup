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
  shellcheckEnabled = pkgs ? shellcheck;
  luacheckEnabled = pkgs.luajitPackages ? luacheck;
  rubyEnabled = pkgs ? ruby;
  markdownlintEnabled = pkgs ? markdownlint-cli2;
  hlintEnabled = pkgs ? hlint;
  eslintEnabled = pkgs ? eslint_d;
  stylelintEnabled = pkgs ? stylelint;
  markdownlintCmd = shellFirstCmd pkgs.markdownlint-cli2 "markdownlint-cli2";
in {
  enable = true;
  lint_after_save = true;

  linters_by_ft = {
    nix = optionalLinter statixEnabled "statix";
    sh = optionalLinter shellcheckEnabled "shellcheck";
    bash = optionalLinter shellcheckEnabled "shellcheck";
    lua = optionalLinter luacheckEnabled "luacheck";
    ruby = optionalLinter rubyEnabled "ruby";
    haskell = optionalLinter hlintEnabled "hlint";
    javascript = optionalLinter eslintEnabled "eslint_d";
    javascriptreact = optionalLinter eslintEnabled "eslint_d";
    typescript = optionalLinter eslintEnabled "eslint_d";
    typescriptreact = optionalLinter eslintEnabled "eslint_d";
    css = optionalLinter stylelintEnabled "stylelint";
    scss = optionalLinter stylelintEnabled "stylelint";
    markdown = optionalLinter markdownlintEnabled "markdownlint-cli2";
  };

  linters = {
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
      cmd = "sh";
      args = ["-c" (shellFirstCmd pkgs.eslint_d "eslint_d") "sh"];
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
      cmd = "sh";
      args = ["-c" (shellFirstCmd pkgs.stylelint "stylelint") "sh"];
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
