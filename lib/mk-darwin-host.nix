{
  darwin,
  inputs,
  nvf,
  self,
  unfreePackageNames,
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
  darwin.lib.darwinSystem {
    inherit (host) system;

    modules =
      [
        ../darwin
      ]
      ++ (host.modules or []);

    specialArgs = {
      inherit inputs machineSettings nvf self unfreePackageNames;
      inherit (host) primaryUser;
    };
  }
