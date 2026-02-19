{primaryUser, ...}: {
  imports = [
    ./packages.nix
    ./git.nix
    ./shell.nix
    ./kitty.nix
    ./nvf.nix
  ];

  home = {
    username = primaryUser;
    stateVersion = "25.05";
    sessionVariables = {
      # shared environment variables
      EDITOR = "nvim";
      TERMINAL = "kitty";
      PAGER = "less";
    };

    # create .hushlogin file to suppress login messages
    file.".hushlogin".text = "";
  };
}
