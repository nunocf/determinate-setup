{
  primaryUser,
  pkgs,
  lib,
  machineProfile ? {},
  ...
}: {
  imports = [
    ./packages.nix
    ./git.nix
    ./shell.nix
    ./kitty.nix
    ./zoxide.nix
    ./nvf.nix
    ./direnv.nix
  ];

  home = {
    username = primaryUser;
    stateVersion = "25.05";
    sessionVariables = {
      # shared environment variables
      EDITOR = "nvim";
      TERMINAL = machineProfile.defaultTerminal or "kitty";
      PAGER = "less";
      BROWSER = "open";
    };

    # create .hushlogin file to suppress login messages
    file.".hushlogin".text = "";
    activation = lib.mkIf (machineProfile.enableDefaultBrowserActivation or false) {
      setDefaultBrowser = lib.hm.dag.entryAfter ["writeBoundary"] ''
        /usr/bin/open -a "${machineProfile.browserApp}" --args --make-default-browser
      '';
    };
  };
}
