{pkgs, ...}: {
  home.packages = with pkgs; [
    pipx
    # vectorcode CLI — broken on Darwin via nixpkgs (dlinfo 2.0.0 test failure).
    # Installed at runtime via pipx instead (see home/default.nix activation).
    # Once upstream fixes dlinfo, add `vectorcode` here and drop the pipx workaround.
    nodejs
    tree-sitter
    nil
    biome
    nixfmt
    fourmolu
    statix
    alejandra
    stylua
    pgformatter
    prettierd
    markdownlint-cli2
  ];
}
