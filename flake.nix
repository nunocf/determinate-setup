{
  description = "My system configuration";

  inputs = {
    # stable channel — tested, less likely to break on macOS
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    # unstable for packages not yet in stable or needing newer versions
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # manages configs
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # system-level software and settings (macOS)
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    # declarative homebrew management (will probably be removed in favour of homebrew-hm)
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    # pinned to the commit we know builds — update deliberately, not on nix flake update
    nvf.url = "github:notashelf/nvf/8265ea062b4c37dc1b9846ec83bb8c9615048ef1";
    nvf.inputs.nixpkgs.follows = "nixpkgs";

    # homebrew via home-manager
    homebrew-hm = {
      url = "github:koalalorenzo/home-manager-brew";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # no releases — tracking HEAD is intentional, it auto-updates the claude binary hourly
    claude-code.url = "github:sadjow/claude-code-nix";
  };

  outputs = {
    self,
    darwin,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    homebrew-hm,
    nvf,
    claude-code,
    ...
  } @ inputs: let
    inherit (nixpkgs) lib;

    hosts = import ./lib/hosts.nix;
    pkgsLib = import ./lib/pkgs.nix {inherit nixpkgs;};
    inherit (pkgsLib) mkPkgs unfreePackageNames;

    mkDarwinHost = import ./lib/mk-darwin-host.nix {
      inherit darwin inputs nvf self unfreePackageNames;
    };
    mkHomeHost = import ./lib/mk-home-host.nix {
      inherit home-manager homebrew-hm inputs mkPkgs nvf self;
    };

    hostsOfType = type: lib.filterAttrs (_: host: host.type == type) hosts;
    darwinHosts = hostsOfType "darwin";
    homeHosts = hostsOfType "home";

    homeConfigurationOutputs = lib.mapAttrs (name: host:
      mkHomeHost {inherit host name;})
    homeHosts;
    homeConfigurationAliases = lib.concatMapAttrs (name: host:
      lib.genAttrs (host.aliases or []) (_: homeConfigurationOutputs.${name}))
    homeHosts;

    systems = lib.unique (lib.mapAttrsToList (_: host: host.system) hosts);
    forAllSystems = lib.genAttrs systems;

    hostBuildChecksFor = system:
      lib.mapAttrs' (name: host:
        lib.nameValuePair "${name}-build" (
          if host.type == "darwin"
          then self.darwinConfigurations.${name}.system
          else homeConfigurationOutputs.${name}.activationPackage
        ))
      (lib.filterAttrs (_: host: host.system == system) hosts);
  in {
    # build darwin flake using:
    # $ darwin-rebuild build --flake .#<name>
    darwinConfigurations = lib.mapAttrs (name: host:
      mkDarwinHost {inherit host name;})
    darwinHosts;

    homeConfigurations = homeConfigurationOutputs // homeConfigurationAliases;

    checks = forAllSystems (system:
      (import ./checks/treesitter-injections.nix {
        pkgs = mkPkgs system;
      })
      // hostBuildChecksFor system);

    devShells = forAllSystems (system:
      import ./lib/dev-shells.nix {
        pkgs = mkPkgs system;
      });

    apps = forAllSystems (system:
      import ./lib/apps.nix {
        pkgs = mkPkgs system;
      });
  };
}
