{pkgs, ...}: {
  home.packages = with pkgs; [
    pipx
    vectorcode
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
