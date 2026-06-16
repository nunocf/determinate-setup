{
  pkgs,
  inputs,
  lib,
  self,
  primaryUser,
  machineSettings,
  unfreePackageNames,
  ...
}: {
  imports = [
    ./homebrew.nix
    ./settings.nix
    inputs.home-manager.darwinModules.home-manager
    inputs.nix-homebrew.darwinModules.nix-homebrew
  ];

  # nix config
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      # disabled due to https://github.com/NixOS/nix/issues/7273
      # auto-optimise-store = true;
    };
    enable = false; # using determinate installer
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) unfreePackageNames;

  # Shared nixpkgs fixes (see lib/overlays.nix). Applied at the system level
  # because home-manager.useGlobalPkgs ignores home-manager's nixpkgs.overlays.
  nixpkgs.overlays = import ../lib/overlays.nix;

  # homebrew installation manager
  nix-homebrew = {
    user = primaryUser;
    enable = true;
    autoMigrate = true;
  };

  # home-manager config
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${primaryUser} = {
      imports = [
        ../home
        {my.machine = machineSettings;}
      ];
    };
    extraSpecialArgs = {
      inherit inputs self primaryUser;
    };
  };

  # macOS-specific settings
  system.primaryUser = primaryUser;
  users.users.${primaryUser} = {
    home = "/Users/${primaryUser}";
    shell = pkgs.zsh;
  };
  environment = {
    systemPackages = [
      pkgs.kitty
      pkgs.direnv
      pkgs.nix-direnv
    ];
    systemPath = [
      "/opt/homebrew/bin"
    ];
    pathsToLink = ["/Applications"];
  };
}
