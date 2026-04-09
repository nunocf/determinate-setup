{
  primaryUser,
  pkgs,
  lib,
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
      TERMINAL = "kitty";
      PAGER = "less";
      BROWSER = "open";
    };

    # create .hushlogin file to suppress login messages
    file.".hushlogin".text = "";
    activation = {
      setDefaultBrowser = lib.hm.dag.entryAfter ["writeBoundary"] ''
        /usr/bin/open -a "Arc" --args --make-default-browser
      '';
    };
  };
}
