{
  enable = true;
  setupOpts = {
    dashboard = import ./dashboard.nix;
    bigfile.enable = true;
    quickfile.enable = true;
    notifier.enable = true;
    indent.enable = true;
    scope.enable = true;
    statuscolumn.enable = false;
    picker.enable = true;
    explorer.enable = true;
    lazygit.enable = true;
    input.enable = true;
  };
}
