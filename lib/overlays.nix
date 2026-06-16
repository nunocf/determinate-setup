# Shared nixpkgs overlays — applied on all machines.
#
# Imported by both home/default.nix (standalone home-manager, e.g. work-macbook)
# and darwin/default.nix (nix-darwin uses home-manager.useGlobalPkgs, which
# ignores home-manager's own nixpkgs.overlays — so the fix must also be applied
# at the system level for my-macbook).
[
  # pipx 1.8.0 has test regressions (whitespace in package specifiers);
  # both nixos-26.05 and nixpkgs-unstable are affected.
  (_: prev: {
    pipx = prev.pipx.overrideAttrs (old: {
      disabledTests =
        (old.disabledTests or [])
        ++ ["test_fix_package_name" "test_parse_specifier_for_metadata"];
    });
  })
]
