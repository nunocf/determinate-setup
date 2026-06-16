{
  home-manager,
  homebrew-hm,
  inputs,
  mkPkgs,
  nvf,
  self,
}: {
  host,
  name,
}: let
  machineSettings =
    host.profile
    // {
      homeConfigurationName = host.profile.homeConfigurationName or name;
    };
in
  home-manager.lib.homeManagerConfiguration {
    pkgs = mkPkgs host.system;

    modules =
      [
        ../home
        {my.machine = machineSettings;}
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
    };
  }
