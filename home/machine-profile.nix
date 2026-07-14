{lib, ...}: let
  inherit (lib) mkOption types;
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

    manageSshConfig = mkOption {
      type = types.bool;
      default = true;
      description = "Whether home-manager owns ~/.ssh/config directly. Set false on machines where an external tool (e.g. pd-aws/pd-ssh) owns ~/.ssh/config; nix then writes only an include fragment at ~/.ssh/config.d/nix.";
    };

    managesSystem = mkOption {
      type = types.bool;
      default = false;
      description = "Whether this host owns system-level nix-darwin state.";
    };
  };
}
