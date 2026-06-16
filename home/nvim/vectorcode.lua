-- vectorcode-nvim is commented out in nix until dlinfo is fixed upstream.
-- Guard with pcall so nvim starts cleanly without it, and works automatically
-- once the plugin is re-enabled.
local ok, vectorcode = pcall(require, "vectorcode")
if ok then
  vectorcode.setup()
end
