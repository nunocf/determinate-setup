{
  nix.enable = true;
  markdown.enable = true;
  haskell.enable = true;
  ruby.enable = true;

  lua = {
    enable = true;
    lsp = {
      lazydev.enable = true;
      servers = [ "lua-language-server" ];
    };
  };

  html.enable = true;
  css.enable = true;
  bash.enable = true;
  ts.enable = true;
}
