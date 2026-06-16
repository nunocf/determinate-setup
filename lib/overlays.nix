# Shared nixpkgs overlays — applied on all machines.
#
# Imported by both home/default.nix (standalone home-manager, e.g. work-macbook)
# and darwin/default.nix (nix-darwin uses home-manager.useGlobalPkgs, which
# ignores home-manager's own nixpkgs.overlays — so the fix must also be applied
# at the system level for my-macbook).
[
  # vectorcode depends on dlinfo via chromadb/phonemizer. dlinfo builds on
  # Darwin, but its tests assert /usr/lib/libdl.dylib exists as a normal path,
  # which is false on modern macOS.
  (_: prev: {
    pythonPackagesExtensions =
      (prev.pythonPackagesExtensions or [])
      ++ (
        if prev.stdenv.hostPlatform.isDarwin
        then [
          (_: pythonPrev: {
            dlinfo = pythonPrev.dlinfo.overridePythonAttrs (old: {
              doCheck = false;
              meta = old.meta // {broken = false;};
            });
          })
        ]
        else []
      );
  })
]
