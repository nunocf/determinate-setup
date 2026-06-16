{
  home-manager,
  homebrew-hm,
  inputs,
  nixpkgs,
  nvf,
  self,
}: let
  mkPkgs = system:
    import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
in
  {
    host,
    name,
  }:
    home-manager.lib.homeManagerConfiguration {
      pkgs = mkPkgs host.system;

      modules =
        [
          ../home
        ]
        ++ (host.modules or [])
        ++ (
          if host.homebrewHm or false
          then [homebrew-hm.homeManagerModules.default]
          else []
        );

      extraSpecialArgs = {
        inherit inputs nvf self;
        inherit (host) primaryUser;
        machineProfile =
          host.profile
          // {
            homeConfigurationName = host.profile.homeConfigurationName or name;
          };
      };
    }
