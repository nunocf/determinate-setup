{
  lib,
  machineProfile ? {},
  ...
}: let
  inherit (lib) mkDefault mkOption types;
in {
  options.my.machine = {
    browserApp = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "macOS application name used as the preferred browser.";
    };

    defaultTerminal = mkOption {
      type = types.str;
      default = "kitty";
      description = "Default terminal name exposed through the TERMINAL environment variable.";
    };

    enableDefaultBrowserActivation = mkOption {
      type = types.bool;
      default = false;
      description = "Whether Home Manager should try to set the default browser during activation.";
    };

    gitEmail = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Git user.email for this machine.";
    };

    gitName = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Git user.name for this machine.";
    };

    githubUser = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "GitHub username for gh and GitHub-aware tools.";
    };

    homeConfigurationName = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Name of the Home Manager configuration backing this machine.";
    };

    managesSystem = mkOption {
      type = types.bool;
      default = false;
      description = "Whether this host owns system-level nix-darwin state.";
    };
  };

  config.my.machine = {
    browserApp = mkDefault (machineProfile.browserApp or null);
    defaultTerminal = mkDefault (machineProfile.defaultTerminal or "kitty");
    enableDefaultBrowserActivation = mkDefault (machineProfile.enableDefaultBrowserActivation or false);
    gitEmail = mkDefault (machineProfile.gitEmail or null);
    gitName = mkDefault (machineProfile.gitName or null);
    githubUser = mkDefault (machineProfile.githubUser or null);
    homeConfigurationName = mkDefault (machineProfile.homeConfigurationName or null);
    managesSystem = mkDefault (machineProfile.managesSystem or false);
  };
}
