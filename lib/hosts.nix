let
  workSettings = import ../hosts/work-macbook/settings.nix;
in {
  my-macbook = {
    type = "darwin";
    system = "aarch64-darwin";
    primaryUser = "nunocf";
    modules = [../hosts/my-macbook/configuration.nix];
    profile = import ../hosts/my-macbook/profile.nix;
  };

  work-macbook = {
    type = "home";
    system = "aarch64-darwin";
    primaryUser = workSettings.primaryUser;
    aliases = ["nferreira@nferreira-M0YXMMFJPX"];
    modules = [../hosts/work-macbook/home.nix];
    homebrewHm = true;
    profile = import ../hosts/work-macbook/profile.nix;
  };
}
