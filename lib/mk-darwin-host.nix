{
  darwin,
  inputs,
  nvf,
  self,
}: {
  host,
  name,
}:
darwin.lib.darwinSystem {
  inherit (host) system;

  modules =
    [
      ../darwin
    ]
    ++ (host.modules or []);

  specialArgs = {
    inherit inputs nvf self;
    inherit (host) primaryUser;
    machineProfile =
      host.profile
      // {
        homeConfigurationName = host.profile.homeConfigurationName or name;
      };
  };
}
