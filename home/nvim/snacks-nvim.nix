{
  enable = true;
  setupOpts = {
    dashboard = import ./dashboard.nix;
    bigfile.enable = true;
    quickfile.enable = true;
    notifier.enable = true;
    indent.enable = true;
    scope.enable = true;
    scroll.enable = true;
    statuscolumn.enable = false;
    words.enable = true;
    picker.enable = true;
  };
}
