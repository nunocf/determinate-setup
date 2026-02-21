{
  enable = true;
  setupOpts = {
    dashboard = import ./dashboard.nix;
    notifier.enable = true;
    indent.enable = true;
    scope.enable = true;
    scroll.enable = true;
    statuscolumn.enable = false;
    words.enable = true;
  };
}
