{
  config,
  primaryUser,
  lib,
  ...
}: let
  machine = config.my.machine;
in {
  imports = [
    ./machine-profile.nix
    ./packages.nix
    ./git.nix
    ./shell.nix
    ./kitty.nix
    ./zoxide.nix
    ./nvf.nix
    ./direnv.nix
    ./ssh.nix
  ];

  programs.home-manager.enable = true;

  home = {
    username = primaryUser;
    homeDirectory = "/Users/${primaryUser}";
    stateVersion = "25.05";
    sessionVariables = {
      # shared environment variables
      EDITOR = "nvim";
      TERMINAL = machine.defaultTerminal;
      PAGER = "less";
      BROWSER = "open";
    };

    # create .hushlogin file to suppress login messages
    file.".hushlogin".text = "";
    activation = lib.mkIf (machine.enableDefaultBrowserActivation && machine.browserApp != null) {
      setDefaultBrowser = lib.hm.dag.entryAfter ["writeBoundary"] ''
        /usr/bin/open -a "${machine.browserApp}" --args --make-default-browser
      '';
    };
  };
}
