{
  description = "My system configuration";

  inputs = {
    # monorepo w/ recipes ("derivations")
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # manages configs
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # system-level software and settings (macOS)
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    # declarative homebrew management (will probably be removed in favour of homebrew-hm)
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    nvf.url = "github:notashelf/nvf";
    nvf.inputs.nixpkgs.follows = "nixpkgs";

    # homebrew via home-manager
    homebrew-hm = {
      url = "github:koalalorenzo/home-manager-brew";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    darwin,
    nixpkgs,
    home-manager,
    homebrew-hm,
    nvf,
    ...
  } @ inputs: let
    inherit (nixpkgs) lib;

    hosts = import ./lib/hosts.nix;
    mkPkgs = system:
      import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

    mkDarwinHost = import ./lib/mk-darwin-host.nix {
      inherit darwin inputs nvf self;
    };
    mkHomeHost = import ./lib/mk-home-host.nix {
      inherit home-manager homebrew-hm inputs nixpkgs nvf self;
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
  in {
    # build darwin flake using:
    # $ darwin-rebuild build --flake .#<name>
    darwinConfigurations = lib.mapAttrs (name: host:
      mkDarwinHost {inherit host name;})
    darwinHosts;

    homeConfigurations = homeConfigurationOutputs // homeConfigurationAliases;

    checks = forAllSystems (system:
      import ./checks/treesitter-injections.nix {
        pkgs = mkPkgs system;
      });
  };
}
