{
  config,
  pkgs,
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

  # Shared nixpkgs fixes (see lib/overlays.nix). Honored here for standalone
  # home-manager (work-macbook); my-macbook applies the same set at the
  # darwin system level since useGlobalPkgs ignores this option.
  nixpkgs.overlays = lib.mkIf (! machine.managesSystem) (import ../lib/overlays.nix);

  programs.home-manager.enable = true;
  manual.manpages.enable = false;

  home = {
    username = primaryUser;
    homeDirectory = "/Users/${primaryUser}";
    # pipx and other user-installed tools land here
    sessionPath = ["$HOME/.local/bin"];
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
  };

  home.activation = lib.mkMerge [
    (lib.mkIf (machine.enableDefaultBrowserActivation && machine.browserApp != null) {
      setDefaultBrowser = lib.hm.dag.entryAfter ["writeBoundary"] ''
        /usr/bin/open -a "${machine.browserApp}" --args --make-default-browser
      '';
    })
  ];
}
