{nixpkgs}: let
  inherit (nixpkgs) lib;

  unfreePackageNames = [
    "claude-code"
    "graphite-cli"
  ];

  mkPkgs = system:
    import nixpkgs {
      inherit system;
      config.allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) unfreePackageNames;
    };
in {
  inherit mkPkgs unfreePackageNames;
}
