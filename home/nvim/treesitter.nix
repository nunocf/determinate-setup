{pkgs}: {
  enable = true;
  fold = false;
  highlight.enable = true;
  textobjects.enable = true;
  autotagHtml = true;
  addDefaultGrammars = false;
  grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
    # ── Languages ─────────────────────────────────────────────────────────
    nix
    haskell
    elixir
    heex
    eex
    sql
    lua
    bash
    ruby

    # ── Web ───────────────────────────────────────────────────────────────
    html
    css
    javascript
    typescript
    tsx
    json

    # ── Config / tooling ──────────────────────────────────────────────────
    yaml
    toml
    dockerfile
    gitignore
    regex

    # ── Neovim internals ──────────────────────────────────────────────────
    markdown
    markdown_inline
    query
    vim
    vimdoc
    diff
  ];
}
