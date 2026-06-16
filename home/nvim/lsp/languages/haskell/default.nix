# Haskell language settings.
# Runtime LSP config lives in config.lua (haskell-tools preconfig, warn_missing_hls,
# diagnostics refresh).  HLS binary override runs after plugin load via
# luaConfigRC.haskell-tools-cleanup in nvf.nix (see hls-cleanup.lua).
{haskell.enable = true;}
