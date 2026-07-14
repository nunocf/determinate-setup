{pkgs, ...}: {
  home.packages = with pkgs; [
    vectorcode
    nodejs
    openssl
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
