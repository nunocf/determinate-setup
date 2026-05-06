{
  config,
  pkgs,
  nvf,
  lib,
  ...
}: {
  imports = [
    nvf.homeManagerModules.default
  ];

  homebrew = {
    enable = true;

    formulae = ["mas"];

    # Massive macOS GUI apps (.dmg/.pkg)
    casks = [];
  };

  home.packages = with pkgs; [
    dockutil
    graphite-cli
    kitty
    curl
  ];

  home.activation.pinKittyToDock = lib.hm.dag.entryAfter ["writeBoundary"] ''
    kitty_app="${config.home.homeDirectory}/Applications/Home Manager Apps/kitty.app"

    if [ -d "$kitty_app" ]; then
      ${pkgs.dockutil}/bin/dockutil --remove kitty --no-restart >/dev/null 2>&1 || true
      ${pkgs.dockutil}/bin/dockutil --add "$kitty_app" --no-restart
      /usr/bin/killall Dock >/dev/null 2>&1 || true
    fi
  '';
}
